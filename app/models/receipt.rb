class Receipt < ActiveRecord::Base
  STATUS_NOT_SUBMITTED  = 'Not-Submitted'
  STATUS_SUBMITTED      = 'Submitted'
  STATUSES = [STATUS_NOT_SUBMITTED, STATUS_SUBMITTED]

  belongs_to :expense_claim
  belongs_to :user,     class_name: 'Refinery::User'
  belongs_to :contact
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: proc { |attr| attr[:description].blank? }

  attr_writer :contact_name
  attr_accessible :contact_id, :contact_name, :date, :line_amount_types, :reference, :status, :sub_total, :total, :line_items_attributes

  validates :expense_claim_id,  presence: true
  validates :contact_id,        presence: true
  validates :user_id,           presence: true
  validates :status,            inclusion: STATUSES
  validates :total,             numericality: { greater_than: 0 }

  before_validation do
    if @contact_name.present?
      self.contact = Contact.find_or_create_by_name!(@contact_name)
    end
  end

  def editable?
    status == 'Not-Submitted'
  end

  def no_of_items
    line_items.count
  end

  def contact_name
    contact.try(:name)
  end

end
