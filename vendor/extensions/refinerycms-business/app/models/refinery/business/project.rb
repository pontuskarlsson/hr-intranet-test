module Refinery
  module Business
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_projects'

      STATUSES = %w(Draft Proposed InProgress Open Completed Cancelled Closed Archived)
      CURRENT_STATUSES = %w(Draft Proposed InProgress Open)

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ' - ' }

      belongs_to :company, optional: true
      #has_many :invoices,       dependent: :nullify
      has_many :sections,       dependent: :destroy

      acts_as_indexed :fields => [:code, :description, :company_label, :status]

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_enumerables :status, STATUSES
      configure_label :code, :description

      delegate :name, to: :company, prefix: true, allow_nil: true

      validates :company_id,    presence: true
      validates :code,          uniqueness: true, allow_blank: true
      validates :start_date,    presence: true
      validates :status,        inclusion: STATUSES

      before_validation do
        self.status ||= STATUSES.first
        self.start_date ||= Date.today
      end

      before_validation(on: :create) do
        self.code = NumberSerie.next_counter!(self.class, :code) if code.blank?
      end

      scope :current, -> { where(status: CURRENT_STATUSES) }
      scope :past, -> { where(status: STATUSES - CURRENT_STATUSES) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)
        if titles.include?(ROLE_INTERNAL)
          where(nil)

        elsif titles.include?(ROLE_EXTERNAL)
          where(company_id: user.company_ids)

        else
          where('1=0')
        end
      end

      def self.for_selected_company(selected_company)
        if selected_company.nil?
          where(nil)
        else
          where(company_id: selected_company.id)
        end
      end

      def self.from_params(params)
        active = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:active, true))
        archived = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:archived, true))

        if active && archived
          where(nil)
        elsif active
          current
        elsif archived
          past
        else
          where('1=0')
        end
      end

    end
  end
end
