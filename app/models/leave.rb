class Leave < ActiveRecord::Base
  belongs_to :user,     class_name: 'Refinery::User'
  belongs_to :event,    class_name: 'Refinery::Calendar::Event'

  attr_accessible :comment, :ends_at, :starts_at

  validates :starts_at,   presence: true
  validates :ends_at,     presence: true
  validates :user_id,     presence: true
  validate do
    if ends_at.present? && starts_at.present?
      errors.add(:ends_at, 'Must be later than Starts At') unless ends_at > starts_at
    end
  end

end
