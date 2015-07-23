class UserSetting < ActiveRecord::Base
  belongs_to :user

  serialize :content, Hash

  attr_accessible :content, :identifier

  validates :user_id,     presence: true, unless: :new_record?
  validates :identifier,  presence: true, uniqueness: { scope: :user_id }

end
