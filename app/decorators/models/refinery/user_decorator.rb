Refinery::User.class_eval do

  attr_accessible :full_name, :password_has_expired

  validates :full_name, presence: true

  devise :password_expirable, :expire_password_after => 10.years

  after_save do
    if password_has_expired and !need_change_password?
      # Means that the password_has_expired checkbox was clicked on save. We
      # need to make the password expired.
      need_change_password!
    end
  end

  def password_has_expired=(val)
    @password_has_expired = val == '1'
  end

  def password_has_expired
    @password_has_expired ||= need_change_password?
  end

end
