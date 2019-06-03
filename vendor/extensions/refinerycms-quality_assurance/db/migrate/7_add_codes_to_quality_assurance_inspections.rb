class AddCodesToQualityAssuranceInspections < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspections, :company_code, :string
    add_index :refinery_quality_assurance_inspections, :company_code, name: 'index_qa_inspections_on_company_code'

    add_column :refinery_quality_assurance_inspections, :supplier_code, :string
    add_index :refinery_quality_assurance_inspections, :supplier_code, name: 'index_qa_inspections_on_supplier_code'

    add_column :refinery_quality_assurance_inspections, :manufacturer_id, :integer
    add_index :refinery_quality_assurance_inspections, :manufacturer_id, name: 'index_qa_inspections_on_manufacturer_id'

    add_column :refinery_quality_assurance_inspections, :manufacturer_label, :string
    add_index :refinery_quality_assurance_inspections, :manufacturer_label, name: 'index_qa_inspections_on_manufacturer_label'

    add_column :refinery_quality_assurance_inspections, :manufacturer_code, :string
    add_index :refinery_quality_assurance_inspections, :manufacturer_code, name: 'index_qa_inspections_on_manufacturer_code'
  end
end
