module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(active reserved redeemed expired)
      DISCOUNT_TYPES = %w(fixed_amount percentage)
      SOURCES = %w(invoice purchase)

      belongs_to :company, optional: true
      belongs_to :article, optional: true
      belongs_to :line_item_sales_purchase,   class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_sales_discount,   class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_sales_move_from,  class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_move_to,   class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_prepay_move_from, class_name: 'InvoiceItem', optional: true
      belongs_to :line_item_sales_move_to,    class_name: 'InvoiceItem', optional: true

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_enumerables :discount_type, DISCOUNT_TYPES
      configure_enumerables :status,        STATUSES
      configure_enumerables :source,        SOURCES
      configure_label :description

      delegate :applicable_to?, :code, to: :article, prefix: true, allow_nil: true

      validates :article_id,      presence: true
      validates :status,          inclusion: STATUSES
      validates :discount_type,   inclusion: DISCOUNT_TYPES, allow_blank: true
      validates :line_item_sales_purchase_id, presence: true, if: :source_is_invoice?
      validates :line_item_sales_move_from_id, presence: true, if: :source_is_invoice?
      validates :line_item_prepay_move_to_id, presence: true, if: :source_is_invoice?
      validates :line_item_sales_move_to_id, presence: true, if: -> { line_item_prepay_move_from_id.present? }

      validate do
        errors.add(:article_id, 'is not a voucher') unless article&.is_voucher
      end

      before_validation(on: :create) do
        assign_code!
      end

      before_validation do
        if line_item_sales_move_to.present?
          self.status = line_item_sales_move_to.invoice.managed_status_is_submitted? ? 'redeemed' : 'reserved'
        elsif valid_to < Date.today
          self.status = 'expired'
        else
          self.status = 'active'
        end
      end

      after_create do
        if source_is_invoice?
          if line_item_prepay_move_to&.description.blank?
            line_item_prepay_move_to.description = "[#{article&.code}{code:#{code}}] issued to #{company_label}, issued: #{valid_from&.to_date&.iso8601}, expires: #{valid_to&.to_date&.iso8601}"
            line_item_prepay_move_to.save || errors.add(:line_item_prepay_move_to_id, 'failed to update')
          end
        end
        throw :abort if errors.any?
      end

      after_save do
        if line_item_prepay_move_from.present? && line_item_prepay_move_from.description.blank?
          line_item_prepay_move_from.description = "[#{article&.code}{code:#{code}}] redeemed"
          line_item_prepay_move_from.save || errors.add(:line_item_prepay_move_from_id, 'failed to update')
        end
        throw :abort if errors.any?
      end

      scope :active, -> { where(status: 'active') }
      scope :reserved, -> { where(status: 'reserved') }
      scope :redeemed, -> { where(status: 'redeemed') }
      scope :expired, -> { where(status: 'expired') }
      scope :valid_for_date, -> (date) { where("#{table_name}.valid_from <= :date AND #{table_name}.valid_to >= :date", date: date) }
      scope :first_in_first_out, -> { order(code: :asc) }

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
        if code.blank?
          self.code = NumberSerie.next_counter!(self.class, :code, pad_length: 7)
        end
      end

    end
  end
end
