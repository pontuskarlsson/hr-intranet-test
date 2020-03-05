module Refinery
  module Business
    module Xero
      module Push
        class Invoices

          CREATE_ATTRIBUTES = {
              type: :invoice_type
          }.freeze

          UPDATE_ATTRIBUTES = {
              reference: 'reference',
              date: 'invoice_date',
              due_date: 'due_date',
              status: 'status',
              currency_rate: 'currency_rate'
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
            xero_invoice.attributes = UPDATE_ATTRIBUTES.each_with_object({}) { |(remote, local), acc|
              acc[remote] = invoice.attributes[local]
            }

            # if invoice.invoice_type == 'ACCREC'
            #   invoice.to_company = invoice.company
            #   invoice.to_contact_id = invoice.contact_id
            #   invoice.seller_reference = invoice.reference
            # else
            #   invoice.from_company = invoice.company
            #   invoice.from_contact_id = invoice.contact_id
            #   invoice.buyer_reference = invoice.reference
            # end

            xero_invoice.line_items = []
            invoice.invoice_items.in_order.each do |invoice_item|
              xero_invoice.add_line_item UPDATE_ITEM_ATTRIBUTES.each_with_object({ tax_type: 'NONE' }) { |(remote, local), acc|
                acc[remote] = invoice_item.attributes[local]
              }
            end
          end

        end
      end
    end
  end
end
