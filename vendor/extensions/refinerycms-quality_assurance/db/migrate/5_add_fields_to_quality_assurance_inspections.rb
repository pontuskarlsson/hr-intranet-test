class AddFieldsToQualityAssuranceInspections < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspections, :fields, :text
    add_column :refinery_quality_assurance_inspections, :company_label, :string
    add_column :refinery_quality_assurance_inspections, :inspection_photo_id, :integer
    add_index :refinery_quality_assurance_inspections, :inspection_photo_id, name: 'index_qa_inspections_on_inspection_photo_id'
  end
end
