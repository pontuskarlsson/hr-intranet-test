class Contact < ActiveRecord::Base
  has_many :receipts, dependent: :nullify

  attr_accessible :guid, :name

  validates :guid,    uniqueness: true, allow_blank: true
  validates :name,    presence: true, uniqueness: true

end
