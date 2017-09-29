module Refinery
  module Marketing
    class Contact < Refinery::Core::BaseModel
      self.table_name = 'refinery_contacts'

      acts_as_indexed :fields => [:name]

      belongs_to :user,         class_name: '::Refinery::User'
      belongs_to :organisation, class_name: 'Contact', primary_key: :base_id
      has_many :employees,      class_name: 'Contact', primary_key: :base_id, foreign_key: :organisation_id

      serialize :custom_fields, Hash

      attr_accessible :base_id, :name, :first_name, :last_name, :address,
                      :city, :skype, :zip, :state, :country, :title, :private,
                      :contact_id, :is_organisation, :mobile, :fax,
                      :website, :phone, :description, :linked_in, :facebook,
                      :industry, :twitter, :email, :organisation_name,
                      :tags_joined_by_comma, :position, :user_id

      validates :base_id, presence: true, uniqueness: true
      validates :name,    presence: true
      validates :user_id, uniqueness: true, allow_nil: true

      def self.employees_for(organisation)
        if (org = where(name: organisation, is_organisation: true).first).present?
          org.employees
        else
          where('1=0')
        end
      end

      def contacts_with_same_tags(limit = 20)
        if tags_joined_by_comma.present?
          cond = (tags_joined_by_comma || '').split(', ').inject([[]]) { |acc, tag|
            acc[0] << 'tags_joined_by_comma LIKE ?'
            acc << "%#{tag}%"
            acc
          }
          cond[0] = cond[0].join(' AND ')
          Contact.where(cond).order(:name).limit(limit)
        else
          []
        end
      end


      # Setters from Base Sync
      def line1=(address)
        self.address = address
      end

      def postal_code=(zip)
        self.zip = zip
      end

    end
  end
end
