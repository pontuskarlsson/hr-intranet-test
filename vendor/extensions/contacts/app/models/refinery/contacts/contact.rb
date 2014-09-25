module Refinery
  module Contacts
    class Contact < Refinery::Core::BaseModel
      self.table_name = 'refinery_contacts'

      belongs_to :organisation, class_name: 'Contact', foreign_key: :base_id
      has_many :employees,      class_name: 'Contact', inverse_of: :organisation

      serialize :custom_fields, Hash

      attr_accessible :base_id, :name, :first_name, :last_name, :address, :city, :skype, :zip, :country, :title, :private, :contact_id, :is_organisation, :mobile, :fax, :website, :phone, :description, :linked_in, :facebook, :industry, :twitter, :email, :organisation_name, :tags_joined_by_comma, :position

      validates :base_id, presence: true, uniqueness: true
    end
  end
end
