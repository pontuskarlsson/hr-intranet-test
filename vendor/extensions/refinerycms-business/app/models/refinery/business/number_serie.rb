module Refinery
  module Business
    class NumberSerie < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_number_series'

      validates :identifier,  presence: true, uniqueness: true

      def self.next_counter!(klass, column)
        identifier = "#{klass.name}##{column}"
        number_serie = find_or_create_by!(identifier: identifier) do |ns|
          ns.last_counter = (klass.maximum(column) || 0).to_i
        end
        increment_counter(:last_counter, number_serie.id)
        number_serie.reload.last_counter
      end
    end
  end
end
