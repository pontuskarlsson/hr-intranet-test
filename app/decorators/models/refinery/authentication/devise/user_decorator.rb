Refinery::Authentication::Devise::User.class_eval do
  has_many :user_settings, dependent: :destroy

  accepts_nested_attributes_for :user_settings

  #attr_accessible :full_name, :password_has_expired, :user_settings_attributes

  validates :full_name, presence: true

  devise :password_expirable,
         :invitable,
         :expire_password_after => 10.years

  acts_as_target devise_resource: :authentication_devise_user,
                 email: :email,
                 email_allowed: ->(user, notifiable, key) { user.active_for_authentication? && user.accepted_or_not_invited? }

  def printable_name
    full_name
  end

  def label
    full_name
  end

  after_save do
    if password_has_expired and !need_change_password?
      # Means that the password_has_expired checkbox was clicked on save. We
      # need to make the password expired.
      need_change_password!
    end
  end

  scope :for_role, -> (title) {
    Refinery::Authentication::Devise::User.joins(:roles).where(refinery_authentication_devise_roles: { title: title })
  }

  def active_for_authentication?
    super && !deactivated
  end

  def password_has_expired=(val)
    @password_has_expired = val == '1'
  end

  def password_has_expired
    @password_has_expired ||= need_change_password?
  end

  def remember_me
    (super == nil) ? '1' : super
  end

  def status
    if deactivated
      'Deactivated'
    elsif created_by_invite?
      if invitation_accepted?
        'Accepted'
      else
        'Invited'
      end

    else
      'Active'
    end
  end

end
