Refinery::Authentication::Devise::User.class_eval do
  has_many :user_settings, dependent: :destroy

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  accepts_nested_attributes_for :user_settings

  validates :full_name, presence: true

  devise :invitable
  # devise :password_expirable,
  #        :invitable,
  #        :expire_password_after => 10.years

  acts_as_target devise_resource: :authentication_devise_user,
                 email: :email,
                 email_allowed: ->(user, notifiable, key) { user.active_for_authentication? && user.accepted_or_not_invited? },
                 batch_email_allowed: ->(user, key) { user.active_for_authentication? && user.accepted_or_not_invited? }

  def printable_name
    full_name
  end

  def label
    full_name
  end

  scope :for_role, -> (title) {
    Refinery::Authentication::Devise::User.joins(:roles).where(refinery_authentication_devise_roles: { title: title })
  }

  def active_for_authentication?
    super && !deactivated
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

  # Returns an email friendly address string.
  #
  # Examples:
  #
  #   "John Doe <john@doe.com>"
  #
  #   "\"John \\\" Doe\" <john@doe.com>"
  #
  def recipient
    address = Mail::Address.new email
    address.display_name = full_name
    address.format
  end

  def self.to_recipients
    select([:email, :full_name]).map(&:recipient)
  end

end
