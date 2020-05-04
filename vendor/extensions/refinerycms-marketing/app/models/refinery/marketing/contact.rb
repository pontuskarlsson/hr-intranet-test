module Refinery
  module Marketing
    class Contact < Refinery::Core::BaseModel
      self.table_name = 'refinery_contacts'

      DT_COLUMNS = %w(id name code is_organisation organisation_name organisation_id email phone mobile country tags_joined_by_comma image_url)

      belongs_to :user,         class_name: '::Refinery::Authentication::Devise::User', optional: true
      belongs_to :organisation, class_name: 'Contact', optional: true
      belongs_to :image,        class_name: '::Refinery::Image', optional: true
      has_many :employees,      class_name: 'Contact', foreign_key: :organisation_id
      has_many :links,          dependent: :destroy
      has_many :linked_links,   as: :linked, class_name: 'Link', dependent: :destroy
      has_many :addresses,      through: :links, source: :linked, source_type: 'Refinery::Marketing::Address'

      #serialize :custom_fields, Hash

      acts_as_indexed :fields => [:name, :email, :organisation_name, :code, :phone, :country, :tags_joined_by_comma]

      configure_label :name

      responds_to_data_tables *DT_COLUMNS

      validates :insightly_id, uniqueness: true, allow_nil: true
      validates :name,    presence: true, unless: proc { |c| c.email.present? }
      validates :user_id, uniqueness: true, allow_nil: true

      before_validation do
        if is_organisation
          self.name = organisation_name if name.blank?
        else
          self.name = [first_name, last_name].reject(&:blank?).join(' ') if name.blank?
        end
      end

      scope :organisations, -> { where(is_organisation: true) }
      scope :non_organisations, -> { where(is_organisation: false) }
      scope :in_crm, -> { where(removed_from_base: false).where.not(insightly_id: nil) }
      scope :not_in_crm, -> { where(insightly_id: nil) }
      scope :without_code, -> { where(code: nil).or(where(code: '')) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include?(ROLE_CRM_MANAGER) || titles.include?(::Refinery::Business::ROLE_INTERNAL)
          in_crm
        else
          none
        end
      end

      def self.employees_for(organisation)
        if (org = where(name: organisation).first).present?
          org.employees
        else
          none
        end
      end

      # Override label configuration to only allow contacts with :name present
      def self.to_source
        where.not(name: nil).pluck(:name).to_json.html_safe
      end

      def contacts_with_same_tags(limit = 20)
        if tags_joined_by_comma.present?
          cond = (tags_joined_by_comma || '').split(', ').inject([[]]) { |acc, tag|
            acc[0] << 'tags_joined_by_comma LIKE ?'
            acc << "%#{tag}%"
            acc
          }
          cond[0] = cond[0].join(' AND ')
          Contact.where(cond).where('id <> ?', id).order(:name).limit(limit)
        else
          []
        end
      end

      def zip
        attributes['zip']
      end


      # Setters from Base Sync
      def line1=(address)
        self.address = address
      end

      def postal_code=(zip)
        self.zip = zip
      end

      def all_address_lines
        if country == 'Sweden'
          [name, address, [zip, city].reject(&:blank?).join(' '), country].reject(&:blank?)
        else
          [name, address, city, zip, state, country].reject(&:blank?)
        end
      end

      def billing_address
        @billing_address ||= links.detect { |l|
          l.relation == 'billing' && l.linked_type == 'Refinery::Marketing::Address'
        }&.linked
      end

      def mail_address
        @mail_address ||= links.detect { |l|
          l.relation == 'mail' && l.linked_type == 'Refinery::Marketing::Address'
        }&.linked
      end

      def ship_address
        @ship_address ||= links.detect { |l|
          l.relation == 'ship' && l.linked_type == 'Refinery::Marketing::Address'
        }&.linked
      end

      def street_address
        @street_address ||= links.detect { |l|
          l.relation == 'street' && l.linked_type == 'Refinery::Marketing::Address'
        }&.linked
      end

      def other_address
        @other_address ||= links.detect { |l|
          l.relation == 'other' && l.linked_type == 'Refinery::Marketing::Address'
        }&.linked
      end

    end
  end
end
