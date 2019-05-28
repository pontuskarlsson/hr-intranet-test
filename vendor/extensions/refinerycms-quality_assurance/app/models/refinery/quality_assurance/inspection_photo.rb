module Refinery
  module QualityAssurance
    class InspectionPhoto < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspection_photos'

      serialize :fields, Hash

      belongs_to :inspection
      belongs_to :inspection_defect
      belongs_to :image,            class_name: '::Refinery::Image'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      validates :inspection_id,   presence: true
      validates :image_id,        presence: true

    end
  end
end
