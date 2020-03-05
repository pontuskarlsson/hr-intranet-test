module Refinery
  module Business
    class InvoiceForm < ApplicationTransForm

      set_main_model :invoice, class_name: '::Refinery::Business::Invoice', proxy: { attributes: %w(is_managed) }

      transaction do

      end

      private

    end
  end
end
