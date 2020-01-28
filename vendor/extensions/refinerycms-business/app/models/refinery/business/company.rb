module Refinery
  module Business
    class Company < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_companies'

      belongs_to :contact,      class_name: 'Refinery::Marketing::Contact', optional: true
      has_many :company_users,  dependent: :destroy
      has_many :parcels,        through: :contact
      has_many :invoices,       dependent: :nullify
      has_many :projects,       dependent: :destroy
      has_many :documents,      dependent: :nullify
      has_many :billables,      dependent: :destroy
      has_many :users,          through: :company_users
      has_many :seller_orders,  dependent: :nullify,    class_name: 'Order',  foreign_key: 'seller_id'
      has_many :buyer_orders,   dependent: :nullify,    class_name: 'Order',  foreign_key: 'buyer_id'
      has_many :vouchers,       dependent: :nullify

      accepts_nested_attributes_for :company_users, reject_if: :all_blank, allow_destroy: true

      delegate :website, :phone, :email, :country, to: :contact, allow_nil: true, prefix: true

      acts_as_indexed :fields => [:code, :name]

      configure_assign_by_label :contact, class_name: '::Refinery::Marketing::Contact'
      configure_label :code, :name, separator: ' '

      responds_to_data_tables :id, :name, :code, contact: [:country, :phone, :website, :email]

      validates :name,          presence: true, uniqueness: true
      validates :code,          presence: true, uniqueness: true
      validates :contact_id,    presence: true, uniqueness: true
      validates :country_code,  inclusion: ISO3166::Country.codes, allow_blank: true

      before_validation do
        if code.blank?
          self.code = NumberSerie.next_counter!(self.class, :code)
        end

        if contact_label.present?
          self.contact = Refinery::Marketing::Contact.organisations.find_by_name(contact_label)
        elsif contact_id.nil? && name.present?
          self.contact = Refinery::Marketing::Contact.organisations.where(name: name).first_or_create!(code: code)
        end
      end

      before_save do
        if contact.present?
          self.country_code = ISO3166::Country.find_country_by_name(contact.country || contact.other_country).try(:un_locode)
          self.city = contact.city || contact.other_city
        end
      end

      # +after_save+ callback to handle propagation of +code+ to Contact. It
      # handles removing the code from any contact that has the same code
      # but is not assigned as the contact for this Company.
      #
      # It also handles assigning the code to the linked contact.
      #
      after_save do
        Refinery::Marketing::Contact.where(code: code).where.not(id: contact_id).each do |c|
          c.update_attributes code: nil
        end

        if contact && contact.code != code
          unless contact.update_attributes code: code
            throw :abort
          end
        end
      end

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include? ROLE_INTERNAL
          where(nil)
        elsif titles.include? ROLE_EXTERNAL
          user.companies
        else
          where('1=0')
        end
      end

      def country
        country_code.present? ? ISO3166::Country[country_code].name : nil
      end

    end
  end
end
