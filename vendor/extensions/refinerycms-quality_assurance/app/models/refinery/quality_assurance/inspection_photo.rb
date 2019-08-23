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

      scope :non_defects, -> { where(inspection_defect_id: nil) }

      def thumb_url
        image_url('45x45#')
      end

      def preview_url
        image_url('190x190#')
      end

      def image_url(size = nil)
        if image.present?
          size.nil? ? image.image.url : image.image.thumb(size).url
        end
      end

    end
  end
end
