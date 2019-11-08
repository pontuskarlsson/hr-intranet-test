Refinery::Image.class_eval do

  def self.create_with_access(params, roles_and_conditions)
    authorizations_access = roles_and_conditions.inject('') { |acc, (role, conditions)|
      cond_str = conditions.map { |k,v| "#{k}:#{v}" }.join(',')
      acc << "[#{role}{#{cond_str}}]"
    }

    create({ authorizations_access: authorizations_access }.reverse_merge(params))
  end

end
