module Refinery
  module Employees
    class XeroAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_accounts'

      has_many :xero_line_items, dependent: :nullify

      attr_accessible :featured, :when_to_use
      attr_accessible :code, :guid, :name, as: :sync_update

      validates :guid,    presence: true, uniqueness: true
      validates :code,    presence: true, uniqueness: { scope: :inactive }, unless: :inactive
      validates :name,    presence: true

      def code_and_name
        [code, name].reject(&:blank?).join(' - ')
      end

      class << self
        def featured
          where(featured: true)
        end

        def sync_from_xero!(account)
          xero_account = find_or_initialize_by_guid(account.account_id)
          xero_account.account_type = account.type
          account.attributes.each_pair do |attr, value|
            xero_account.send("#{attr}=", value) if xero_account.respond_to?("#{attr}=")
          end
          xero_account.save!
        end
      end

    end
  end
end
