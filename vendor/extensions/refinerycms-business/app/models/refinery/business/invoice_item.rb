module Refinery
  module Business
    class InvoiceItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoice_items'

      TRANSACTION_TYPES = %w(sales_purchase sales_discount prepay_in prepay_discount_in prepay_out prepay_discount_out)
      ACCOUNT_CODES = {
          'sales_purchase'      => '3020',
          'sales_discount'      => '3730',
          'prepay_in'           => '2421-01',
          'prepay_out'          => '2421-01',
          'prepay_discount_in'  => '2421-02',
          'prepay_discount_out' => '2421-02'
      }.freeze

      belongs_to :invoice
      belongs_to :article,          foreign_key: :item_code, primary_key: :code, optional: true
      has_many :issued_vouchers,    class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_prepay_in_id
      has_many :redeemed_vouchers,  class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_sales_purchase_id,
                                    dependent: :nullify
      has_many :redeemed_prepay_vouchers, class_name: '::Refinery::Business::Voucher',
                                    foreign_key: :line_item_prepay_out_id,
                                    dependent: :nullify
      has_many :sales_billables,    class_name: '::Refinery::Business::Billable',
                                    foreign_key: :line_item_sales_id,
                                    dependent: :nullify
      has_many :discount_billables, class_name: '::Refinery::Business::Billable',
                                    foreign_key: :line_item_discount_id,
                                    dependent: :nullify

      configure_enumerables :transaction_type, TRANSACTION_TYPES

      delegate :is_voucher, to: :article, prefix: true, allow_nil: true

      validates :line_item_id,      uniqueness: true, allow_blank: true
      validates :transaction_type,  inclusion: TRANSACTION_TYPES, allow_nil: true
      validates :unit_amount,       numericality: { greater_than_or_equal_to: 0.0 },
                                    if: -> (ii) { ii.transaction_type.in?(%w(sales_purchase prepay_in prepay_discount_out)) }
      validates :unit_amount,       numericality: { less_than_or_equal_to: 0.0 },
                                    if: -> (ii) { ii.transaction_type.in?(%w(sales_discount prepay_out prepay_discount_in)) }
      validates :item_code,         presence: true,
                                    if: -> (ii) { ii.transaction_type.in?(%w(sales_purchase sales_discount prepay_in prepay_discount_in)) }
      validates :quantity,          numericality: { greater_than: 0.0 },
                                    if: -> (ii) { ii.transaction_type.present? }

      validate do
        if article.present?
          errors.add(:item_code, 'belongs to the wrong account') unless invoice&.account_id == article.account_id

          if transaction_type_is_prepay_in?
            errors.add(:item_code, 'not a voucher') unless article.is_voucher
            errors.add(:item_code, 'cannot be a discount') if article.is_discount
          elsif transaction_type_is_prepay_discount_in?
            errors.add(:item_code, 'not a voucher') unless article.is_voucher
            errors.add(:item_code, 'not a discount') unless article.is_discount
          elsif transaction_type_is_sales_purchase?
            errors.add(:item_code, 'cannot be a voucher') if article.is_voucher
            errors.add(:item_code, 'cannot be a discount') if article.is_discount
          elsif transaction_type_is_sales_discount?
            errors.add(:item_code, 'cannot be a voucher') if article.is_voucher
            errors.add(:item_code, 'not a discount') unless article.is_discount
          end
        end
      end

      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.invoice_items.maximum(:line_item_order) || 0) + 1
        end

        self.line_amount = calculated_line_amount

        self.account_code = ACCOUNT_CODES[transaction_type]
      end

      before_destroy do
        if issued_vouchers.exists?
          if issued_vouchers.redeemed.or(issued_vouchers.reserved).exists? or redeemed_vouchers.redeemed.exists?
            errors.add(:invoice_id, 'cannot delete a transaction for already redeemed vouchers')
          else
            issued_vouchers.destroy_all
          end
        end
        if redeemed_vouchers.reserved.exists?
          redeemed_vouchers.reserved.update_all(
              status: 'active',
              line_item_prepay_out_id: nil,
              line_item_prepay_discount_out_id: nil,
              line_item_sales_purchase_id: nil,
              line_item_sales_discount_id: nil,
          )
        end
        throw :abort if errors.any?
      end

      scope :in_order,        -> { order(line_item_order: :asc) }
      TRANSACTION_TYPES.each do |transaction_type|
        scope transaction_type, -> { where(transaction_type: transaction_type) }
      end
      scope :transactional,   -> { where.not(transaction_type: nil) }
      scope :informative,     -> { where(transaction_type: nil) }

      def informative?
        transaction_type.nil?
      end

      def label
        description
      end

      def calculated_line_amount
        quantity * unit_amount unless quantity.nil? || unit_amount.nil?
      end

      def vouchers_by_issued_invoice
        redeemed_vouchers.group_by do |v|
          [
              v.line_item_prepay_discount_in&.invoice || invoice,
              v.discount_amount
          ]
        end
      end

      def vouchers_by_discount
        redeemed_vouchers.group_by(&:discount_amount)
      end

    end
  end
end
