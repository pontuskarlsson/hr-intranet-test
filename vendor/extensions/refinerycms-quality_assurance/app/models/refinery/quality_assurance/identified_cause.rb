module Refinery
  module QualityAssurance
    class IdentifiedCause < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_identified_causes'

      belongs_to :cause
      belongs_to :inspection_defect

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
