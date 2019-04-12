Refinery::Business::Company.class_eval do

  # Associations
  has_many :inspections,            class_name: '::Refinery::QualityAssurance::Inspection',
                                    dependent: :nullify
  has_many :supplier_inspections,   class_name: '::Refinery::QualityAssurance::Inspection',
                                    foreign_key: :supplier_id,
                                    dependent: :nullify

  def top_defects
    res = Refinery::QualityAssurance::InspectionDefect
        .where(inspection_id: inspection_ids)
        .where('defect_id IS NOT NULL')
        .group(:defect_id)
        .order('COUNT(defect_id) DESC')
        .select('COUNT(defect_id) as no_of_defects, defect_id')
        .limit(5)

    defects = Refinery::QualityAssurance::Defect.where(id: res.map(&:defect_id))

    defects.each_with_index.each_with_object({}) { |(defect, i), acc|
      acc[defect.label] = i
    }
  end

  def pass_rate_qty
    inspections.select('SUM(po_qty) as sum_qty, result').group('result').each_with_object({}) { |insp, acc|
      acc[insp.result] = insp.sum_qty
    }
  end

  def pass_rate_inspections
    inspections.select('COUNT(id) as no_of_inspections, result').group('result').each_with_object({}) { |insp, acc|
      acc[insp.result] = insp.no_of_inspections
    }
  end

end
