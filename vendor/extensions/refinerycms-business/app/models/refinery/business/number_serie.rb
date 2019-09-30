module Refinery
  module Business
    class NumberSerie < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_number_series'

      validates :identifier,  presence: true, uniqueness: true

      def label
        identifier
      end

      def self.next_counter!(klass, column, options = {})
        identifier = "#{klass.name}##{column}"
        prefix = options[:prefix] || ''
        pad_length = options[:pad_length] || 5
        number_serie = find_or_create_by!(identifier: identifier) do |ns|
          max = klass.maximum(column) || "#{prefix}0"
          ns.last_counter = max.gsub(prefix, '').to_i
        end
        increment_counter(:last_counter, number_serie.id)
        [prefix, number_serie.reload.last_counter.to_s.rjust(pad_length, '0')].join ''
      end
    end
  end
end
