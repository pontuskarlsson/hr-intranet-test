module Refinery
  module Business
    class Billable < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_billables'

      TYPES = %w(commision time product)

      belongs_to :company
      belongs_to :project
      belongs_to :section
      belongs_to :invoice

      validates :company_id,    presence: true
      validates :type,          inclusion: TYPES

    end
  end
end
