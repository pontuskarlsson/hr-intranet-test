module Refinery
  module Business
    class Section < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_sections'

      TYPES = %w(VBO QA)

      belongs_to :project
      has_many :sections, dependent: :destroy
      has_many :billables, dependent: :nullify

      validates :project_id,    presence: true
      validates :description,   presence: true
      validates :section_type,  inclusion: TYPES, uniqueness: { scope: :project_id }
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

      def label
        description
      end

    end
  end
end
