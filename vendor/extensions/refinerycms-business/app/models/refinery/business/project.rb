module Refinery
  module Business
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_projects'

      STATUSES = %w(Draft Proposed InProgress Open Completed Cancelled Closed Archived)

      belongs_to :company
      has_many :invoices,       dependent: :nullify
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
        self.code = NumberSerie.next_counter!(self.class, :code).to_s.rjust(5, '0') if code.blank?
      end

      scope :current, -> { where(status: %w(Draft Proposed InProgress Open)) }
      
      def label
        [code, description].reject(&:blank?).join ' - '
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
      end

    end
  end
end
