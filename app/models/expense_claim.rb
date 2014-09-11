class ExpenseClaim < ActiveRecord::Base
  STATUS_NOT_SUBMITTED  = 'Not-Submitted'
  STATUS_SUBMITTED      = 'Submitted'
  STATUSES = [STATUS_NOT_SUBMITTED, STATUS_SUBMITTED]

  belongs_to :user, class_name: 'Refinery::User'
  has_many :receipts,   dependent: :destroy

  attr_accessible :description

  validates :user_id,         presence: true
  validates :status,          inclusion: STATUSES
  validates :description,     presence: true

  scope :not_submitted, where(guid: '')
  scope :submitted, where("#{table_name}.guid <> ''")

  def submittable?
    status == 'Not-Submitted' and receipts.any? && user.try(:xero_guid).present?
  end

end
