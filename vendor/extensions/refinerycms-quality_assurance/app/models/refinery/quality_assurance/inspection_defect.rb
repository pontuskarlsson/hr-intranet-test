module Refinery
  module QualityAssurance
    class InspectionDefect < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspection_defects'

      belongs_to :inspection
      belongs_to :defect

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      validates :inspection_id,   presence: true
      validates :defect_id,       uniqueness: { scope: :inspection_id }, allow_nil: true

      after_save do
        inspection.recalculate_defects!
      end

      after_destroy do
        inspection.recalculate_defects!
      end

    end
  end
end
