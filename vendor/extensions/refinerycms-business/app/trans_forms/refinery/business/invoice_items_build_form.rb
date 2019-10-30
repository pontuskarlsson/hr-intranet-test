module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

      attribute :monthly_minimum,       Integer, default: 10

      attr_accessor :invoice

      validates :invoice,       presence: true

      def model=(model)
        self.invoice = model
      end

      transaction do
        invoice.billables.each do |billable|

        end
      end

      private

    end
  end
end
