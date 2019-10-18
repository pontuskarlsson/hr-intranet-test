module Refinery
  module Business
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_projects'

      STATUSES = %w(Draft Proposed InProgress Open Completed Cancelled Closed Archived)
      CURRENT_STATUSES = %w(Draft Proposed InProgress Open)

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ' - ' }

      belongs_to :company
      #has_many :invoices,       dependent: :nullify
      has_many :sections,       dependent: :destroy

      acts_as_indexed :fields => [:code, :description, :company_label, :status]

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

      def self.to_source
        where(nil).pluck(:code, :description).map(&PROC_LABEL).to_json.html_safe
      end

      def self.find_by_label(label)
        find_by_code label.split(' - ').first
      end

      def label
        PROC_LABEL.call(code, description)
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
      end

      def self.from_params(params)
        active = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:active, true))
        archived = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:archived, true))

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
