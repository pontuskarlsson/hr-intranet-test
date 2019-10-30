module Refinery
  module Business
    module Xero
      module Sync
        class Contacts

          attr_reader :account, :errors

          def initialize(account, errors)
            @account = account
            @errors = errors
          end

          def sync!(xero_contact)
            if xero_contact.account_number.present?
              code = xero_contact.account_number.rjust(5, '0')
              company = ::Refinery::Business::Company.find_by(code: code)

              if company&.contact
                assign_xero_id company.contact, xero_contact.contact_id
              end
            end
          rescue ::ActiveRecord::RecordNotSaved => e
            errors << e
          end

          private

          def assign_xero_id(contact, xero_id)
            if account.organisation == 'Happy Rabbit Limited'
              contact.update_attributes xero_hr_id: xero_id

            elsif account.organisation == 'Happy Rabbit Trading Limited'
              contact.update_attributes xero_hrt_id: xero_id
            end
          end

        end
      end
    end
  end
end
