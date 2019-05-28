class AddDefectLabelToQualityAssuranceInspectionDefects < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspection_defects, :defect_label, :string
    add_column :refinery_quality_assurance_inspection_defects, :can_fix, :boolean
  end
end
