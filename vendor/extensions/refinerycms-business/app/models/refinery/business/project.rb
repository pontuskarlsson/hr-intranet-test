module Refinery
  module Business
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_projects'

      STATUSES = %w(Draft Proposed InProgress Completed Cancelled)

      belongs_to :company
      has_many :sections, dependent: :destroy

      validates :company_id,    presence: true
      validates :code,          uniqueness: true, allow_blank: true
      validates :start_date,    presence: true
      validates :status,        inclusion: STATUSES

      before_validation do
        self.status ||= STATUSES.first
      end

      scope :current, -> { where(status: %w(Draft Proposed InProgress)) }
      
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
