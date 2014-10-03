module Refinery
  module Employees
    class XeroApiKeyfile < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_api_keyfiles'

      validates :organisation,  presence: true, uniqueness: true
      validates :key_content,   presence: true
    end
  end
end
