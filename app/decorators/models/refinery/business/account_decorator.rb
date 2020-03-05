Refinery::Business::Account.class_eval do

  has_many :omni_authorizations,    class_name: '::Omni::Authorization', dependent: :destroy

end
