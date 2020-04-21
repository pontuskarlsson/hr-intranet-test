module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(active reserved redeemed expired)
      DISCOUNT_TYPES = %w(fixed_amount percentage)
      SOURCES = %w(invoice purchase)

      belongs_to :company
      belongs_to :article
      belongs_to :line_item_sales_purchase,       class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_sales_discount,       class_name: 'InvoiceItem', optional: true
      # belongs_to :line_item_sales_move_from,  class_name: 'InvoiceItem', optional: true
      # belongs_to :line_item_prepay_move_to,   class_name: 'InvoiceItem', optional: true
      # belongs_to :line_item_prepay_move_from, class_name: 'InvoiceItem', optional: true
      # belongs_to :line_item_sales_move_to,    class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_in,            class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_discount_in,   class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_out,           class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_discount_out,  class_name: 'InvoiceItem', optional: true

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_enumerables :discount_type, DISCOUNT_TYPES
      configure_enumerables :status,        STATUSES
      configure_enumerables :source,        SOURCES
      configure_label :description

      delegate :applicable_to?, :code, to: :article, prefix: true, allow_nil: true

      validates :status,          inclusion: STATUSES
      validates :discount_type,   inclusion: DISCOUNT_TYPES, allow_blank: true
      validates :valid_from,      presence: true
      validates :valid_to,        presence: true
      # validates :line_item_sales_purchase_id, presence: true, if: :source_is_invoice?
      # validates :line_item_sales_move_from_id, presence: true, if: :source_is_invoice?
      # validates :line_item_prepay_move_to_id, presence: true, if: :source_is_invoice?
      # validates :line_item_sales_move_to_id, presence: true, if: -> { line_item_prepay_move_from_id.present? }
      validates :line_item_prepay_in_id,            presence: true, if: -> { line_item_sales_purchase_id.nil? }
      validates :line_item_prepay_discount_in_id,   presence: true, if: -> { line_item_prepay_discount_out_id.present? || (line_item_sales_discount_id.present? && line_item_prepay_in_id.present?) }
      validates :line_item_prepay_out_id,           presence: true, if: -> { line_item_sales_purchase_id.present? && line_item_prepay_in_id.present? }
      validates :line_item_prepay_discount_out_id,  presence: true, if: -> { line_item_prepay_discount_in_id.present? && line_item_prepay_out_id.present? }
      validates :line_item_sales_purchase_id,       presence: true, if: -> { line_item_prepay_out_id.present? }
      validates :line_item_sales_discount_id,       presence: true, if: -> { line_item_sales_purchase_id.present? && line_item_prepay_discount_out_id.present? }

      validate do
        errors.add(:article_id, 'is not a voucher') unless article&.is_voucher

        if valid_to.present? && valid_from.present?
          errors.add(:valid_to, 'must be greater than valid from') unless valid_to > valid_from
        end

        if line_item_prepay_out.present?
          unless line_item_prepay_out.unit_amount + line_item_prepay_in.unit_amount == 0
            errors.add(:line_item_prepay_out_id, 'out price not matching in price')
          end
        end

        if line_item_prepay_discount_out.present?
          unless line_item_prepay_discount_out.unit_amount + line_item_prepay_discount_in&.unit_amount.to_d == 0
            errors.add(:line_item_prepay_discount_out_id, 'out price not matching in price')
          end
          unless line_item_prepay_discount_out.unit_amount + line_item_sales_discount&.unit_amount.to_d == 0
            errors.add(:line_item_prepay_discount_out_id, 'out price not matching in price')
          end
        end
      end

      before_validation(on: :create) do
        assign_code! if code.blank?
      end

      before_validation do
        if line_item_sales_purchase.present?
          self.status = line_item_sales_purchase.invoice.managed_status_is_authorised? ? 'redeemed' : 'reserved'
        # elsif valid_to.present? && valid_to < Date.today
        #   self.status = 'expired'
        else
          self.status ||= 'active'
        end
      end

      after_create do
        if source_is_invoice?
          # if line_item_prepay_move_to&.description.blank?
          #   line_item_prepay_move_to.description = "[#{article&.code}{code:#{code}}] issued to #{company_label}, issued: #{valid_from&.to_date&.iso8601}, expires: #{valid_to&.to_date&.iso8601}"
          #   line_item_prepay_move_to.save || errors.add(:line_item_prepay_move_to_id, 'failed to update')
          # end
          if line_item_prepay_in.present? && line_item_prepay_in.description.blank?
            line_item_prepay_in.description = "[#{article&.code}{code:#{code}}] issued to #{company_label}, issued: #{valid_from&.to_date&.iso8601}, expires: #{valid_to&.to_date&.iso8601}"
            line_item_prepay_in.save || errors.add(:line_item_prepay_in_id, 'failed to update')
          end
          if line_item_prepay_discount_in.present? && line_item_prepay_discount_in.description.blank?
            line_item_prepay_discount_in.description = "[#{article&.code}-DISC{code:#{code}}] issued to #{company_label}, issued: #{valid_from&.to_date&.iso8601}, expires: #{valid_to&.to_date&.iso8601}"
            line_item_prepay_discount_in.save || errors.add(:line_item_prepay_discount_in_id, 'failed to update')
          end
        end
        throw :abort if errors.any?
      end

      after_save do
        # if line_item_prepay_move_from.present? && line_item_prepay_move_from.description.blank?
        #   line_item_prepay_move_from.description = "[#{article&.code}{code:#{code}}] redeemed"
        #   line_item_prepay_move_from.save || errors.add(:line_item_prepay_move_from_id, 'failed to update')
        # end
        if line_item_prepay_out.present? && line_item_prepay_out.description.blank?
          line_item_prepay_out.description = "[#{article&.code}{code:#{code}}] redeemed"
          line_item_prepay_out.save || errors.add(:line_item_prepay_out_id, 'failed to update')
        end
        if line_item_prepay_discount_out.present? && line_item_prepay_discount_out.description.blank?
          line_item_prepay_discount_out.description = "[#{article&.code}-DISC{code:#{code}}] redeemed"
          line_item_prepay_discount_out.save || errors.add(:line_item_prepay_discount_out_id, 'failed to update')
        end
        throw :abort if errors.any?
      end

      scope :active, -> { where(status: 'active') }
      scope :reserved, -> { where(status: 'reserved') }
      scope :redeemed, -> { where(status: 'redeemed') }
      scope :expired, -> { where(status: 'expired') }
      scope :valid_for_date, -> (date) { where("#{table_name}.valid_to >= :date", date: date) }
      scope :first_in_first_out, -> { order(code: :asc) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include? ROLE_INTERNAL
          where(nil)
        elsif titles.include? ROLE_EXTERNAL
          where(company_id: user.company_ids)
        else
          where('1=0')
        end
      end

      def self.for_selected_company(selected_company)
        if selected_company.nil?
          where(nil)
        else
          where(company_id: selected_company.id)
        end
      end

      def self.applicable_to(invoice, article_code = '')
        scope = invoice.invoice_for_month.present? ? active.valid_for_date(invoice.invoice_for_month) : active

        if article_code.present?
          articles = Article.is_public.where(id: scope.uniq.pluck(:article_id)).select { |a| a.applicable_to?(article_code) }
          scope.where(article_id: articles.map(&:id))
        else
          scope
        end
      end

      def assign_code!
        self.code = NumberSerie.next_counter!(self.class, :code, pad_length: 7)
      end

    end
  end
end
