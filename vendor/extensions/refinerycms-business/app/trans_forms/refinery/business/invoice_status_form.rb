module Refinery
  module Business
    class InvoiceStatusForm < ApplicationTransForm

      STATUS_TRANSITIONS = {
          'draft' => %w(submitted_for_approval approved issued),
          'submitted_for_approval' => %w(draft approved issued),
          'approved' => %w(issued)
      }

      set_main_model :invoice, class_name: '::Refinery::Business::Invoice', proxy: { attributes: %w(managed_status) }

      validate do
        errors.add(:invoice, 'is not managed') unless invoice.is_managed
        errors.add(:managed_status, 'is not changed') if invoice.managed_status == managed_status

        unless Array(STATUS_TRANSITIONS[invoice.managed_status]).include? managed_status
          errors.add(:managed_status, 'cannot transition to that status')
        end
      end

      transaction do
        invoice.managed_status = managed_status
        invoice.save!

        if invoice.managed_status == 'issued'
          Delayed::Job.enqueue(::Refinery::Business::IssueInvoiceJob.new(invoice.id))
        end
      end

      private

    end
  end
end
