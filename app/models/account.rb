class Account < ActiveRecord::Base
  has_many :line_items, dependent: :nullify

  attr_accessible :code, :guid, :name

  validates :guid,    presence: true, uniqueness: true
  validates :code,    presence: true, uniqueness: true
  validates :name,    presence: true

  def code_and_name
    "#{code} - #{name}"
  end

end
