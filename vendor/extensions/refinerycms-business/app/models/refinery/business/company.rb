module Refinery
  module Business
    class Company < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_companies'

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ' ' }

      belongs_to :contact,      class_name: 'Refinery::Marketing::Contact'
      has_many :company_users,  dependent: :destroy
      has_many :parcels,        through: :contact
      has_many :invoices,       dependent: :nullify
      has_many :projects,       dependent: :destroy
      has_many :users,          through: :company_users

      accepts_nested_attributes_for :company_users, reject_if: :all_blank, allow_destroy: true

      acts_as_indexed :fields => [:code, :name]

      validates :name,          presence: true, uniqueness: true
      validates :code,          presence: true, uniqueness: true
      validates :contact_id,    presence: true, uniqueness: true

      before_validation do
        if code.blank?
          self.code = NumberSerie.next_counter!(self.class, :code).to_s.rjust(5, '0')
        end

        if contact_label.present?
          self.contact = Refinery::Marketing::Contact.organisations.find_by_name(contact_label)
        elsif contact_id.nil? && name.present?
          self.contact = Refinery::Marketing::Contact.organisations.where(name: name).first_or_create!(code: code)
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
          contact.update_attributes code: code
        end
      end

      def self.to_source
        where(nil).pluck(:code, :name).map(&PROC_LABEL).to_json.html_safe
      end

      def self.find_by_label(label)
        find_by_code label.split(' ').first
      end

      def label
        PROC_LABEL.call(code, name)
      end

      def contact_label
        @contact_label ||= contact.try(:name)
      end

      def contact_label=(label)
        @contact_label = label
      end

    end
  end
end
