class CompanyContactForm < ApplicationTransForm

  set_main_model :contact, class_name: '::Refinery::Marketing::Contact'

  attribute :name,        String, default: proc { |f| f.contact&.name }
  attribute :br_number,   String, default: proc { |f| f.contact&.br_number }

  attribute :address_forms_attributes,  Hash

  validates :name,        presence: true
  validates :contact,     presence: true

  attr_accessor :contact

  def persisted?
    contact&.persisted?
  end

  def model=(model)
    self.contact = model
  end

  def address_forms
    []
  end

  def address_forms_for(relation, params = {})
    @address_forms ||= {}
    @address_forms[relation] ||= Refinery::Marketing::AddressForm.new_in_model(
        contact,
        params.merge(relation: relation),
        current_user
    )
  end

  transaction do
    contact.attributes = contact_params
    contact.save!

    each_nested_hash_for address_forms_attributes do |attr|
      if attr['relation'].present?
        form = address_forms_for(attr['relation'], attr)
        form.save!
      end
    end
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
