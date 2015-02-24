# encoding: utf-8
Refinery::Employees.configure do |config|
  # Configure what attribute to use when referencing Refinery::User model
  # to associate with Parcels.
  #
  # By default, the refinerycms-authentication engine does not have any
  # column to specify the full name for a User record. So when trying
  # to associate parcels with the User model, the only column we can use
  # is the +username+ column. But if that is not enough for your particular
  # case, then you can manually create a migration to extend the User model
  # with a better suited column (like +full_name+ for example) and then
  # specify that column here.
  #
  config.user_attribute_reference = :full_name
end
