module Refinery
  module Marketing
    class Contact < Refinery::Core::BaseModel
      self.table_name = 'refinery_contacts'

      belongs_to :organisation, class_name: 'Contact', primary_key: :base_id
      has_many :employees,      class_name: 'Contact', primary_key: :base_id, foreign_key: :organisation_id

      serialize :custom_fields, Hash

      attr_accessible :base_id, :name, :first_name, :last_name, :address,
                      :city, :skype, :zip, :country, :title, :private,
                      :contact_id, :is_organisation, :mobile, :fax,
                      :website, :phone, :description, :linked_in, :facebook,
                      :industry, :twitter, :email, :organisation_name,
                      :tags_joined_by_comma, :position

      validates :base_id, presence: true, uniqueness: true
      validates :name,    presence: true

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

    end
  end
end
