Refinery::Resource.class_eval do
  extend ::Refinery::ResourceAuthorizations::Helpers

  def self.create_resources_with_access(params, roles_and_conditions)
    authorizations_access = access_string_for roles_and_conditions

    create_resources({ authorizations_access: authorizations_access }.reverse_merge(params))
  end

end
