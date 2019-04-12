module Refinery
  module QualityAssurance
    class Defect < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_defects'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      validates :category_code,     presence: true
      validates :category_name,     presence: true
      validates :defect_code,       presence: true, uniqueness: { scope: :category_code }
      validates :defect_name,       presence: true

      def label
        "#{category_code}.#{defect_code} #{category_name} - #{defect_name}"
      end

    end
  end
end
