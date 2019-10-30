module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(active redeemed expired)
      DISCOUNT_TYPES = %w(fixed_amount percentage)

      belongs_to :company
      belongs_to :line_item_sales_purchase,   class_name: 'LineItem'
      belongs_to :line_item_sales_discount,   class_name: 'LineItem'
      belongs_to :line_item_sales_move_from,  class_name: 'LineItem'
      belongs_to :line_item_prepay_move_to,   class_name: 'LineItem'
      belongs_to :line_item_prepay_move_from, class_name: 'LineItem'
      belongs_to :line_item_sales_move_to,    class_name: 'LineItem'

      validates :article_id,      presence: true
      validates :status,          inclusion: STATUSES
      validates :discount_type,   inclusion: DISCOUNT_TYPES

      validate do
        errors.add(:article_id, 'is not a voucher') unless article&.is_voucher
      end

      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.line_items.maximum(:line_item_order) || 0) + 1
        end
      end

      scope :active, -> { where(status: 'active') }

      def label
        description
      end

      def applies_to?(item_code)
        applies_to = constraint['applies_to'] || []
        applies_to.include? item_code
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

    end
  end
end
