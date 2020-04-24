module Refinery
  module Business
    class PurchaseInvoiceBuildForm < ApplicationTransForm

      attr_accessor :invoice

      validates :invoice,           presence: true

      validate do
        if invoice.present?
          errors.add(:invoice, 'company is missing') unless invoice.company.present?
          errors.add(:invoice, 'is not managed') unless invoice.is_managed

          errors.add(:invoice, 'purchase invoices cannot have Billables') if invoice.billables.exists?

          errors.add(:invoice, 'must have a Purchase associated') if invoice.purchase.nil?
        end
      end

      def model=(model)
        self.invoice = model
      end


      transaction do

        #
        # STEP 1
        #
        # Delete previous invoice items and set the basic Invoice attributes
        #
        invoice.invoice_items.each(&:destroy!)
        invoice.reload

        # invoice.invoice_for_month = invoice_for_month
        # invoice.plan_title = plan_title
        # invoice.buyer_reference = buyer_reference
        # invoice.plan_description = plan_description

        @opening_balance_by_code = invoice.company.vouchers.applicable_to(invoice).joins(:article).group("#{Refinery::Business::Article.table_name}.code").count
        @closing_balance_by_code = @opening_balance_by_code.dup


        #
        # STEP 4
        #
        # After having gone through all billables and allocated them, we now need to check
        # if there is anything out of the minimum quantities, that remain and we need
        # to issue vouchers for.
        #
        invoice.purchase.charges.each do |charge|
          @closing_balance_by_code[charge.article_label] ||= 0
          @closing_balance_by_code[charge.article_label] += charge.unallocated

          issued_vouchers_for_charge, matching_items = charge.build_vouchers_for(invoice)

          issued_vouchers_for_charge.each do |voucher|
            issued_vouchers << voucher
          end

          matching_items.each_pair do |prepay_in, prepay_discount_in|
            matching_discounts(prepay_in) << prepay_discount_in
          end

        end


        # Time to add description items and set correct order
        #
        line_item_order = 0
        handled = []
        if invoice.invoice_for_month.present?
          handled << invoice.informative_item_per("- - - Invoice for Purchase #{invoice.invoice_date.iso8601}", line_item_order: line_item_order += 1)
        end

        invoice.purchase.charges.each do |charge|
          if charge.qty > 0
            handled << invoice.informative_item_per(charge.informative_description, line_item_order: line_item_order += 1)
          end
        end

        handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("- - - Credits: Opening Balance", line_item_order: line_item_order += 1)
        @opening_balance_by_code.each do |code, balance|
          handled << invoice.informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end


        prepay_ins = invoice.invoice_items.select(&:transaction_type_is_prepay_in?)
        if prepay_ins.any?
          # Add section header
          handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << invoice.informative_item_per("- - - Credits: Issued", line_item_order: line_item_order += 1)

          prepay_ins.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item

            Array(matching_discounts(invoice_item)).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
        end

        handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("- - - Credits: Closing Balance", line_item_order: line_item_order += 1)
        @closing_balance_by_code.each do |code, balance|
          handled << invoice.informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end

        handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("- - - Stripe References", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("StripePI: #{invoice.purchase&.stripe_payment_intent_id}", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("StripeCH: #{invoice.purchase&.stripe_charge_id}", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("StripePO: #{invoice.purchase&.stripe_payout_id}", line_item_order: line_item_order += 1)

        # Any previously existing invoice items, that have not been added the to handled array, is no longer used
        # and can be removed
        #
        # Or this should not happen, so maybe raise an error if there is any items not handled?
        remaining = invoice.invoice_items.select { |invoice_item| !handled.include? invoice_item }
        #remaining.map(&:destroy!)
        raise 'Unhandled invoice items' if remaining.any?

        # We call :calculated_line_amount here, because :line_amount is not set until a before_save callback
        invoice.total_amount = invoice.invoice_items.reduce(0) { |acc, invoice_item| acc + invoice_item.calculated_line_amount.to_f }

        invoice.plan_opening_balance = @opening_balance_by_code.values.reduce(&:+) || 0
        invoice.plan_closing_balance = @closing_balance_by_code.values.reduce(&:+) || 0


        invoice.plan_issued = invoice.purchase.charges.reduce(0.0) { |acc, c| acc + c.qty }
        invoice.plan_redeemed = 0

        # Store one charge per article label, but set the qty to 0. Otherwise it would be displayed as a minimum which
        # does not make sense on a Purchase Invoice (Receipt)
        # invoice.minimums = invoice.purchase.charges.each_with_object({}) { |charge, acc|
        #   acc[charge.article_label] ||= charge.dup.tap { |c| c.qty = '0' }
        # }.values
        invoice.minimums = invoice.purchase.charges

        invoice.save!

        issued_vouchers.map { |v|
          v.line_item_prepay_in = v.line_item_prepay_in
          v.line_item_prepay_discount_in = v.line_item_prepay_discount_in
          v.save!
        }
      end

      private

      def issued_vouchers
        @issued_vouchers ||= []
      end

      def matching_discounts(line_item)
        @matching_discounts ||= {}
        @matching_discounts[line_item] ||= []
        @matching_discounts[line_item]
      end

    end
  end
end
