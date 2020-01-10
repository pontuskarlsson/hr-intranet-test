module Refinery
  module Business
    class InvoiceItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoice_items'

      TRANSACTION_TYPES = %w(sales sales_offset discount pre_pay pre_pay_redeem)

      belongs_to :invoice, optional: true
      belongs_to :article,          foreign_key: :item_code, primary_key: :code, optional: true
      has_many :purchased_vouchers, class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_sales_purchase_id,
                                    dependent: :destroy
      has_many :redeemed_vouchers,  class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_sales_move_to_id,
                                    dependent: :nullify
      has_many :sales_billables,    class_name: '::Refinery::Business::Billable',
                                    foreign_key: :line_item_sales_id,
                                    dependent: :nullify
      has_many :discount_billables, class_name: '::Refinery::Business::Billable',
                                    foreign_key: :line_item_discount_id,
                                    dependent: :nullify

      configure_enumerables :transaction_type, TRANSACTION_TYPES

      delegate :is_voucher, to: :article, prefix: true, allow_nil: true

      validates :invoice_id,        presence: true
      validates :line_item_id,      uniqueness: true, allow_blank: true
      validates :transaction_type,  inclusion: TRANSACTION_TYPES, allow_nil: true

      validate do
        if article.present? && invoice.present?
          errors.add(:article_id, 'belongs to the wrong account') unless invoice.account_id == article.account_id
        end
      end

      before_create do
        if transaction_type_is_sales_offset?
          self.description = 'Sales offset to Pre Payments' if description.blank?
        end
      end

      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.invoice_items.maximum(:line_item_order) || 0) + 1
        end

        self.line_amount = calculated_line_amount

        self.account_code =
            case transaction_type
            when 'sales', 'sales_offset' then '3020'
            when 'discount' then '3730'
            when 'pre_pay', 'pre_pay_redeem' then '2421'
            else nil
            end
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
        throw :abort if errors.any?
      end

      scope :in_order,        -> { order(line_item_order: :asc) }
      scope :discount,        -> { where(transaction_type: 'discount') }
      scope :pre_pay,         -> { where(transaction_type: 'pre_pay') }
      scope :pre_pay_redeem,  -> { where(transaction_type: 'pre_pay_redeem') }
      scope :sales,           -> { where(transaction_type: 'sales') }
      scope :sales_offset,    -> { where(transaction_type: 'sales_offset') }
      scope :informative,     -> { where(transaction_type: nil) }

      def label
        description
      end

      def calculated_line_amount
        quantity * unit_amount unless quantity.nil?
      end

    end
  end
end
