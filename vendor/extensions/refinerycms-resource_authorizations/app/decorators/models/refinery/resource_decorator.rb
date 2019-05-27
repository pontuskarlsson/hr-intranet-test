Refinery::Resource.class_eval do

  def self.create_resources_with_access(params, roles_and_conditions)
    authorizations_access = roles_and_conditions.inject('') { |acc, (role, conditions)|
      cond_str = conditions.map { |k,v| "#{k}:#{v}" }.join(',')
      acc << "[#{role}{#{cond_str}}]"
    }

    create_resources({ authorizations_access: authorizations_access }.reverse_merge(params))
  end

end
