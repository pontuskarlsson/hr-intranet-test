class AddCompanyProjectReferenceToInspections < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspections, :company_project_reference, :string
    add_index :refinery_quality_assurance_inspections, :company_project_reference, name: 'index_qa_inspections_on_company_project_reference'

    add_column :refinery_quality_assurance_inspections, :project_code, :string
    add_index :refinery_quality_assurance_inspections, :project_code

    add_column :refinery_quality_assurance_inspections, :code, :string
    add_index :refinery_quality_assurance_inspections, :code
  end
end
