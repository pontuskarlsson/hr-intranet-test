class LineItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :account

  attr_accessible :account_id, :description, :discount_rate, :item_code, :quantity, :tax_amount, :tax_type, :unit_amount

  validates :description,     presence: true
  validates :quantity,        numericality: { greater_than: 0 }
  validates :line_amount,     numericality: { greater_than: 0 }
  validates :account_id,      presence: true

  before_validation do
    self.line_amount = line_total
  end

  def line_total
    quantity * unit_amount
  end

end
