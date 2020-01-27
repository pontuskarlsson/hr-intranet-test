class PurchaseForm < ApplicationTransForm
  include Portal::Wizard::ActiveRecord

  attribute :article_code,                String
  attribute :qty,                         Integer


  attribute :company_name,                String
  attribute :country,                     String
  attribute :full_name,                   String

  attribute :stripe_session_id,           String

  has_wizard steps: %w(products details payment)

  validate do
    if wizard_validates?('products')
      errors.add(:article_code, :missing) unless article_code.present?
      errors.add(:qty, :invalid) unless qty.is_a?(Integer) && qty > 0
    end
    if wizard_validates?('details')
      errors.add(:company_name, :missing) unless company_name.present?
      errors.add(:country, :missing) unless country.present?
      errors.add(:full_name, :missing) unless full_name.present?
    end
  end

  transaction do

  end

  private


end
