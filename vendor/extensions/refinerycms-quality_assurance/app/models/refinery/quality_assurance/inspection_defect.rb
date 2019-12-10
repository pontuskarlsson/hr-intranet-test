module Refinery
  module QualityAssurance
    class InspectionDefect < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspection_defects'

      belongs_to :inspection, optional: true
      belongs_to :defect, optional: true
      has_many :inspection_photos, dependent: :nullify

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      validates :inspection_id,   presence: true
      validates :defect_id,       uniqueness: { scope: :inspection_id }, allow_nil: true

      before_save do
        self.defect_label = defect.label if defect.present?
      end

      after_save do
        inspection.recalculate_defects!
      end

      after_destroy do
        inspection.recalculate_defects!
      end

      def display_can_fix
        if can_fix.nil?
          'N/A'
        elsif can_fix
          'Yes'
        else
          'No'
        end
      end

      def total_no_of_defects
        critical + major + minor
      end

      def detailed_no_of_defects
        "#{critical}/#{major}/#{minor}"
      end

    end
  end
end
