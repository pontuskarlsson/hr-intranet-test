module Refinery
  module Marketing
    class Address < Refinery::Core::BaseModel
      self.table_name = 'refinery_marketing_addresses'

      belongs_to :owner,      class_name: '::Refinery::Business::Company', optional: true

      validates :country,     presence: true

      def country_code
        # :find_all_by returns a Hash where the keys are all matched country codes
        ISO3166::Country.find_all_by(:name, country).keys.first
      end

      def country_code=(country_code)
        self.country = ISO3166::Country[country_code]&.name
      end

    end
  end
end
