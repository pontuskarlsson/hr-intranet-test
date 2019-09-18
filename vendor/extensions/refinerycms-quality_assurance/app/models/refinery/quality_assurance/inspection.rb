module Refinery
  module QualityAssurance
    class Inspection < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_inspections'

      RESULTS = %w(Pass Sort Hold Reject)
      INSPECTION_TYPES = %w(In-line Final Re-Final)
      PO_TYPES = %w(Bulk SMS Other)

      STATUSES = %w(Draft Planned Booked Inspected Notified Alerted Delivered Confirmed)

      serialize :fields, Hash

      belongs_to :job
      belongs_to :inspected_by,       class_name: 'Refinery::Authentication::Devise::User'
      belongs_to :business_product,   class_name: 'Refinery::Business::Product' # Not correct to let it be a belongs_to here, and maybe let Job handle...
      belongs_to :business_section,   class_name: 'Refinery::Business::Section' # Let Job handle
      belongs_to :company,            class_name: 'Refinery::Business::Company'
      belongs_to :inspection_photo
      belongs_to :manufacturer,       class_name: 'Refinery::Business::Company'
      belongs_to :resource,           class_name: 'Refinery::Resource'
      belongs_to :supplier,           class_name: 'Refinery::Business::Company'
      has_many :inspection_defects,   dependent: :destroy
      has_many :defects,              through: :inspection_defects
      has_many :inspection_photos,    dependent: :destroy

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:company_label, :supplier_label, :manufacturer_label, :po_number, :result, :product_code, :product_description]

      delegate :image_url, :preview_url, :thumb_url, to: :inspection_photo, prefix: true, allow_nil: true
      delegate :code, :company_label, :project_code, :status, to: :job, prefix: true, allow_nil: true

      validates :result,          inclusion: RESULTS, allow_blank: true
      validates :inspection_type, inclusion: INSPECTION_TYPES, allow_blank: true
      validates :po_type,         inclusion: PO_TYPES, allow_blank: true
      validates :document_id,     uniqueness: true, allow_blank: true
      validates :status,          inclusion: STATUSES

      before_validation(on: :create) do
        self.status ||= 'Draft'
        assign_code!
      end

      validate do
        if job.present?
          errors.add(:company_id, :invalid) unless job.company_id == company_id
        end
      end
      
      before_save do
        if company.present?
          self.company_code = company.code
          self.company_label = company.name
        end
        if manufacturer.present?
          self.manufacturer_code = manufacturer.code
          self.manufacturer_label = manufacturer.name
        end
        if supplier.present?
          self.supplier_code = supplier.code
          self.supplier_label = supplier.name
        end
        if business_section.present?
          self.company_project_reference = business_section.business_project.try(:company_reference)
          self.project_code = business_section.business_project.try(:code)
        end
      end
      
      scope :recent, -> (no_of_records) { order(inspection_date: :desc).limit(no_of_records) }
      scope :for_companies, -> (companies) { where(company_id: Array(companies).map(&:id)) }
      scope :inspected_by, -> (user) { where(inspected_by_id: user.id) }
      scope :similar_to, -> (inspection) { where.not(id: inspection.id).where(inspection.attributes.slice('company_id', 'supplier_id')) }

      def self.top_defects
        inspection_ids = where(nil).pluck(:id)
        res = Refinery::QualityAssurance::InspectionDefect
                  .where(inspection_id: inspection_ids)
                  .where.not(defect_id: nil)
                  .group(:defect_id)
                  .order('COUNT(defect_id) DESC')
                  .select('COUNT(defect_id) as no_of_defects, defect_id')
                  .limit(5)

        defects = Refinery::QualityAssurance::Defect.where(id: res.map(&:defect_id))

        defects.each_with_index.each_with_object({}) { |(defect, i), acc|
          acc[defect.label] = i
        }
      end

      def self.pass_rate_qty
        select('SUM(po_qty) as sum_qty, result').group('result').each_with_object({ 'Pass' => 0, 'Reject' => 0, 'Hold' => 0 }) { |insp, acc|
          acc[insp.result] = insp.sum_qty
        }
      end

      def self.pass_rate_inspections
        select('COUNT(id) as no_of_inspections, result').group('result').each_with_object({}) { |insp, acc|
          acc[insp.result] = insp.no_of_inspections
        }
      end


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

      def calendar_label
        "(#{inspection_type[0]}) #{product_label}"
      end

      def chart_defects
        inspection_defects.each_with_object({}) { |inspection_defect, acc|
          acc[inspection_defect.defect.try(:label) || 'Unknown'] = [inspection_defect.critical, inspection_defect.major, inspection_defect.minor].sum
        }
      end

      def pass?
        result == 'Pass'
      end

      def hold?
        result == 'Hold'
      end

      def reject?
        result == 'Reject'
      end

      def display_inspection_date(format = '%b %e, %Y (%a)')
        if inspection_date.present?
          inspection_date.strftime(format)
        else
          '&nbsp;'.html_safe
        end
      end

      def assign_code!
        self.code = ::Refinery::Business::NumberSerie.next_counter!(self.class, :code, prefix: 'QA-', pad_length: 6) if code.blank?
      end

    end
  end
end
