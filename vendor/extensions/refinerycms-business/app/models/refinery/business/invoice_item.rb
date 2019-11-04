module Refinery
  module Business
    class InvoiceItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoice_items'

      TRANSACTION_TYPES = %w(sales sales_offset discount pre_pay pre_pay_redeem)

      belongs_to :invoice
      has_many :purchased_vouchers, class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_sales_purchase_id,
                                    dependent: :destroy
      has_many :redeemed_vouchers,  class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_sales_move_to_id,
                                    dependent: :nullify

      validates :invoice_id,        presence: true
      validates :line_item_id,      uniqueness: true, allow_blank: true
      validates :transaction_type,  inclusion: TRANSACTION_TYPES, allow_blank: true

      before_create do
        if transaction_type_is_sales_offset?
          self.description = 'Sales offset to Pre Payments' if description.blank?
        end
      end

      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.invoice_items.maximum(:line_item_order) || 0) + 1
        end

        self.line_amount = quantity * unit_amount unless quantity.nil?
      end

      before_destroy do
        if purchased_vouchers.redeemed.exists? or redeemed_vouchers.redeemed.exists?
          errors.add(:invoice_id, 'cannot delete a transaction for already redeemed vouchers')
        end
        if redeemed_vouchers.reserved.exists?
          redeemed_vouchers.reserved.update_all(
              status: 'active',
              line_item_prepay_move_from_id: nil,
              line_item_sales_move_to_id: nil,
          )
        end
        errors.empty?
      end

      scope :in_order,        -> { order(line_item_order: :asc) }
      scope :discount,        -> { where(transaction_type: 'discount') }
      scope :pre_pay,         -> { where(transaction_type: 'pre_pay') }
      scope :pre_pay_redeem,  -> { where(transaction_type: 'pre_pay_redeem') }
      scope :sales,           -> { where(transaction_type: 'sales') }
      scope :sales_offset,    -> { where(transaction_type: 'sales_offset') }

      def label
        description
      end

      TRANSACTION_TYPES.each do |tt|
        define_method :"transaction_type_is_#{tt}?" do
          transaction_type == tt
        end
      end

      def display_transaction_type
        if transaction_type.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.transaction_types.#{transaction_type}"
        end
      end

      def self.transaction_type_options
        TRANSACTION_TYPES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.transaction_types.#{k}"),k] }
      end

    end
  end
end
