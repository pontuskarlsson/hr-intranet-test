module Refinery
  module QualityAssurance
    class PossibleCause < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_possible_causes'

      belongs_to :cause
      belongs_to :defect

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      delegate :category_code, :category_name, :cause_code, :cause_name, :code, :description, :label, :title,
               to: :cause, prefix: true, allow_nil: true

    end
  end
end
