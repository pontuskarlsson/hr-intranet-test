module Refinery
  module Business
    class CompanyBillingForm < ApplicationTransForm

      set_main_model :company, class_name: '::Refinery::Business::Company', proxy: { attributes: %w() }

      attribute :billing_accounts_attributes,   Hash

      validates :company,     presence: true

      def model=(model)
        self.company = model
      end

      def billing_accounts
        company&.billing_accounts || []
      end

      def billing_account
        billing_accounts.detect(&:primary) || billing_accounts.build
      end

      transaction do
        each_nested_hash_for billing_accounts_attributes do |attr|
          update_billing_account! attr
        end
      end

      private

      def update_billing_account!(attr, allowed = %w(email_addresses))
        if attr['id'].present?
          billing_account = find_from! billing_accounts, attr['id']

          if attr['_destroy'] == '1'
            billing_account.destroy!
          else
            billing_account.attributes = attr.slice(*allowed)
            billing_account.save!
          end

        else
          billing_account = billing_accounts.build(attr.slice(*allowed))
          billing_account.name = company&.name
          billing_account.primary = true
          billing_account.save!
        end
      end

    end
  end
end
