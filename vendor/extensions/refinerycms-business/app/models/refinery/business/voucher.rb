module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(active reserved redeemed expired)
      DISCOUNT_TYPES = %w(fixed_amount percentage)

      belongs_to :company
      belongs_to :article
      belongs_to :line_item_sales_purchase,   class_name: 'InvoiceItem'
      belongs_to :line_item_sales_discount,   class_name: 'InvoiceItem'
      belongs_to :line_item_sales_move_from,  class_name: 'InvoiceItem'
      belongs_to :line_item_prepay_move_to,   class_name: 'InvoiceItem'
      belongs_to :line_item_prepay_move_from, class_name: 'InvoiceItem'
      belongs_to :line_item_sales_move_to,    class_name: 'InvoiceItem'

      delegate :applicable_to?, :code, to: :article, prefix: true, allow_nil: true

      validates :article_id,      presence: true
      validates :status,          inclusion: STATUSES
      validates :discount_type,   inclusion: DISCOUNT_TYPES, allow_blank: true
      validates :line_item_sales_purchase_id, presence: true
      validates :line_item_sales_move_from_id, presence: true
      validates :line_item_prepay_move_to_id, presence: true
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
        if line_item_prepay_move_to&.description.blank?
          line_item_prepay_move_to.description = "[#{article&.code}{code:#{code}}] issued to #{company_label}, issued: #{valid_from&.to_date&.iso8601}, expires: #{valid_to&.to_date&.iso8601}"
          line_item_prepay_move_to.save || errors.add(:line_item_prepay_move_to_id, 'failed to update')
        end
        errors.empty?
      end

      after_save do
        if line_item_prepay_move_from.present? && line_item_prepay_move_from.description.blank?
          line_item_prepay_move_from.description = "[#{article&.code}{code:#{code}}] redeemed"
          line_item_prepay_move_from.save || errors.add(:line_item_prepay_move_from_id, 'failed to update')
        end
        errors.empty?
      end

      scope :active, -> { where(status: 'active') }
      scope :reserved, -> { where(status: 'reserved') }
      scope :redeemed, -> { where(status: 'redeemed') }
      scope :expired, -> { where(status: 'expired') }
      scope :valid_for_date, -> (date) { where("#{table_name}.valid_from <= :date AND #{table_name}.valid_to >= :date", date: date) }
      scope :first_in_first_out, -> { order(code: :asc) }

      def label
        description
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
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

      def display_discount_type
        if discount_type.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.discount_types.#{discount_type}"
        end
      end

      def self.discount_type_options
        DISCOUNT_TYPES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.discount_types.#{k}"),k] }
      end

      def display_status
        if status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.statuses.#{status}"
        end
      end

      def self.status_options
        STATUSES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses.#{k}"),k] }
      end

      def assign_code!
        if code.blank?
          self.code = NumberSerie.next_counter!(self.class, :code, pad_length: 7)
        end
      end

    end
  end
end
