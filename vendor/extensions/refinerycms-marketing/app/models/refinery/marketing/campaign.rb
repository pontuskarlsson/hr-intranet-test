module Refinery
  module Marketing
    class Campaign < Refinery::Core::BaseModel
      self.table_name = 'refinery_marketing_campaigns'

      has_many :landing_pages

      validates :title, presence: true, uniqueness: true

    end
  end
end
