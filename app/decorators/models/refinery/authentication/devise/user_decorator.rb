Refinery::Authentication::Devise::User.class_eval do
  has_many :user_settings, dependent: :destroy

  accepts_nested_attributes_for :user_settings

  #attr_accessible :full_name, :password_has_expired, :user_settings_attributes

  validates :full_name, presence: true

  devise :password_expirable, :expire_password_after => 10.years

  acts_as_target devise_resource: :authentication_devise_user, email: :email, email_allowed: true

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

  def password_has_expired=(val)
    @password_has_expired = val == '1'
  end

  def password_has_expired
    @password_has_expired ||= need_change_password?
  end

  def remember_me
    (super == nil) ? '1' : super
  end

  def wants_notification_for?(other_employee)
    return false if other_employee.user_id == id

    user_setting = user_settings.find_by_identifier('leave_notification') || user_settings.build(identifier: 'leave_notification', content: { 'receive_for' => 'all' })
    content = user_setting.content || {}
    case content['receive_for']
      when 'all' then true
      when 'none' then false
      when 'employees' then content['employees']["employee_#{other_employee.id}"] == '1'
      when 'offices'
        employment_contract = other_employee.employment_contracts.current_contracts.first
        employment_contract.present? && content['offices']["office_#{ employment_contract.country }"] == '1'
    end
  end

end
