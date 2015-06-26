Refinery::Role.class_eval do

  # Associations
  has_many :page_roles, class_name: '::Refinery::PageRoles::PageRole', dependent: :destroy
  has_many :pages,      through: :page_roles

end
