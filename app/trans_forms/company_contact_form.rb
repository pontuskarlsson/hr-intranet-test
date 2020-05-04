class CompanyContactForm < ApplicationTransForm

  attribute :name,        String, default: proc { |f| f.contact&.name }
  attribute :br_number,   String, default: proc { |f| f.contact&.br_number }

  attribute :addresses_attributes,  Hash

  validates :name,        presence: true
  validates :contact,     presence: true

  attr_accessor :contact

  def model=(model)
    self.contact = model
  end

  transaction do
    contact.attributes = contact_params
    contact.save!
  end

  private

  def contact_params(allowed = %i(name br_number))
    attributes.slice(*allowed)
  end

  def update_contact(contact)
    contact.br_number = br_number
    contact.name
  end

end
