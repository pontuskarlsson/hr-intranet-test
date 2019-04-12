module Refinery
  module Business
    class Section < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_sections'

      TYPES = %w(VBO QA)

      belongs_to :company
      has_many :sections, dependent: :destroy

      validates :project_id,    presence: true
      validates :description,   presence: true
      validates :section_type,  inclusion: TYPES
      validates :start_date,    presence: true

      before_validation do
        self.start_date ||= project.try(:start_date)
      end

      validate do
        if project.present?
          if start_date.present? && project.start_date > start_date
            errors.add(:start_date, 'cannot be earlier than project start')
          end
        end
      end

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        @project_label = label
      end

    end
  end
end
