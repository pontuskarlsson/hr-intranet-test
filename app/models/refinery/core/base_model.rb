require 'active_record'

module Refinery
  module Core
    class BaseModel < ActiveRecord::Base

      self.abstract_class = true

      class << self
        def random(number_of_records = 1)
          # Determines if it is necessary to randomize. For example, if
          # there are only two records and number_of_records is 2, then
          # just return those.
          max_offset = count - ( number_of_records - 1 )
          if max_offset <= 1
            scoped
          else
            offset(rand(max_offset)).limit(number_of_records)
          end
        end
      end

    end
  end
end
