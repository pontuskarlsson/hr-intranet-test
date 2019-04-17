module Refinery
  module Business
    class Company < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_companies'

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ' ' }

      belongs_to :contact,      class_name: 'Refinery::Marketing::Contact'
      has_many :company_users,  dependent: :destroy
      has_many :projects,       dependent: :destroy
      has_many :users,          through: :company_users

      validates :name,          presence: true, uniqueness: true
      validates :code,          uniqueness: true, allow_blank: true
      validates :contact_id,    uniqueness: true, allow_blank: true

      before_validation(on: :create) do
        if code.blank?
          self.code = NumberSerie.next_counter!(self.class, :code).to_s.rjust(5, '0')
        end

        if contact_id.nil? && name.present?
          self.contact = Refinery::Marketing::Contact.organisations.without_code.find_by_name(name)
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
