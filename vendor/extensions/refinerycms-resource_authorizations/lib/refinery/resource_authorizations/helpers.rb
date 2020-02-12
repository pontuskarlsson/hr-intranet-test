module Refinery
  module ResourceAuthorizations
    module Helpers

      def access_string_for(roles_and_conditions)
        roles_and_conditions.inject('') { |acc, (role, conditions)|
          cond_str = conditions.map { |k,v| "#{k}:#{v}" }.join(',')
          acc << "[#{role}{#{cond_str}}]"
        }
      end

    end
  end
end
