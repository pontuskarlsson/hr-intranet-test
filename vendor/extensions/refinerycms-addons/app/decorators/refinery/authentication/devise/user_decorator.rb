Refinery::Authentication::Devise::User.class_eval do

  has_many :comments,     as: :comment_by, class_name: '::Refinery::Addons::Comment', dependent: :nullify

end
