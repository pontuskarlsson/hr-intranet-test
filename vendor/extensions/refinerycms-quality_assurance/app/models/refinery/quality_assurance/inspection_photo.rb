module Refinery
  module QualityAssurance
    class InspectionPhoto < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspection_photos'

      REGEX_MEASUREMENT = /\AMeasurement\.[0-9]+\.MeasurementPhoto\z|\Acc\.[0-9]+\.cd\z/
      REGEX_PRODUCT = /\AProduct\.[0-9]+\.ProductPhoto\z|\Afp\.[0-9]+\.fq\z/
      REGEX_PREVIEW = /\APreview\z|\Ad\z/
      REGEX_DEFECT = /\ADefect\.[0-9]+\.DefectPhoto\.[0-9]+\.DefectPhotoCanvas\z|\Acj\.[0-9]+\.do\.[0-9]+\.dp\z/

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

      def measurement_photo?
        (fields['key'] || '')[REGEX_MEASUREMENT]
      end

      def product_photo?
        (fields['key'] || '')[REGEX_PRODUCT]
      end

      def preview_photo?
        (fields['key'] || '')[REGEX_PREVIEW]
      end

      def defect_photo?
        (fields['key'] || '')[REGEX_DEFECT]
      end

      def other_photo?
        !measurement_photo? && !product_photo? && !preview_photo? && !defect_photo?
      end

    end
  end
end
