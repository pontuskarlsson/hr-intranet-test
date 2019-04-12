module Refinery
  module QualityAssurance
    class Inspection < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspections'

      RESULTS = %w(Pass Sort Hold Reject)
      INSPECTION_TYPES = %w(In-line Final Re-Final)
      PO_TYPES = %w(Bulk SMS Other)

      belongs_to :company,  class_name: 'Refinery::Business::Company'
      belongs_to :supplier,  class_name: 'Refinery::Business::Company'
      belongs_to :resource, class_name: 'Refinery::Resource'
      has_many :inspection_defects, dependent: :destroy
      has_many :defects, through: :inspection_defects

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      validates :company_id,      presence: true
      validates :result,          inclusion: RESULTS, allow_blank: true
      validates :inspection_type, inclusion: INSPECTION_TYPES, allow_blank: true
      validates :po_type,         inclusion: PO_TYPES, allow_blank: true
      validates :document_id,     uniqueness: true, allow_blank: true

      scope :recent, -> (no_of_records) { order(inspection_date: :desc).limit(no_of_records) }

      def recalculate_defects!
        self.total_critical, self.total_major, self.total_minor =
            inspection_defects.pluck(:critical, :major, :minor).inject([0,0,0]) { |(tot_cr, tot_ma, tot_mi), (cr, ma, mi)|
              [tot_cr+cr, tot_ma+ma, tot_mi+mi]
            }
        save!
      end

      def label
        [po_number, product_code, product_description].reject(&:blank?).first
      end

      def product_label
        [product_code, product_description].reject(&:blank?).first
      end

      def chart_defects
        inspection_defects.includes(:defect).each_with_object({}) { |inspection_defect, acc|
          acc[inspection_defect.defect.try(:label) || 'Unknown'] = [inspection_defect.critical, inspection_defect.major, inspection_defect.minor].sum
        }
      end

    end
  end
end
