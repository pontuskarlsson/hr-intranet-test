module Refinery
  module Business
    module Xero
      module Push
        class Invoices

          CREATE_ATTRIBUTES = {
              type: :invoice_type
          }.freeze

          DEFAULT_VALUES = {
              line_amount_types: 'NoTax'
          }.freeze

          UPDATE_ATTRIBUTES = {
              reference: 'reference',
              date: 'invoice_date',
              due_date: 'due_date',
              status: 'status',
              currency_code: 'currency_code',
              currency_rate: 'currency_rate'
          }.freeze

          DEFAULT_ITEM_VALUES = {
              tax_type: 'NONE'
          }.freeze

          UPDATE_ITEM_ATTRIBUTES = {
              description: 'description',
              unit_amount: 'unit_amount',
              quantity: 'quantity',
              account_code: 'account_code',
              item_code: 'item_code',
              line_item_id: 'line_item_id'
          }.freeze

          attr_reader :account, :errors

          def initialize(client, errors)
            @client = client
            @errors = errors
          end

          def update!(invoice, xero_invoice)
            xero_invoice.attributes = UPDATE_ATTRIBUTES.reduce(DEFAULT_VALUES) { |acc, (remote, local)|
              acc.merge(remote => invoice.attributes[local])
            }

            xero_invoice.line_items = []
            ordered_invoice_items = invoice.invoice_items.in_order.each do |invoice_item|
              xero_invoice.add_line_item UPDATE_ITEM_ATTRIBUTES.reduce(DEFAULT_ITEM_VALUES) { |acc, (remote, local)|
                acc.merge(remote => invoice_item.attributes[local])
              }
            end

            if xero_invoice.save
              invoice.invoice_id = xero_invoice.invoice_id
              invoice.updated_date_utc = xero_invoice.updated_date_utc
              invoice.save!

              xero_invoice.line_items.each_with_index do |line_item, i|
                invoice_item = ordered_invoice_items[i]
                invoice_item.line_item_id = line_item.line_item_id
                invoice_item.save!
              end
              true
            else
              false
            end
          end

        end
      end
    end
  end
end
