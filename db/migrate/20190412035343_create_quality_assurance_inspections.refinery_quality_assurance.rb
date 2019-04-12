# This migration comes from refinery_quality_assurance (originally 1)
class CreateQualityAssuranceInspections < ActiveRecord::Migration

  def up
    create_table :refinery_quality_assurance_inspections do |t|
      t.integer :company_id
      t.integer :supplier_id
      t.string :supplier_label
      t.integer :business_section_id
      t.integer :business_product_id
      t.integer :assigned_to_id
      t.integer :resource_id
      t.integer :inspected_by_id
      t.string :inspected_by_name
      t.string :document_id
      t.string :result
      t.date :inspection_date
      t.integer :inspection_sample_size
      t.string :inspection_type
      t.string :po_number
      t.string :po_type
      t.integer :po_qty
      t.integer :available_qty
      t.string :product_code
      t.string :product_description
      t.string :product_colour_variants
      t.string :inspection_standard
      t.integer :acc_critical
      t.integer :acc_major
      t.integer :acc_minor
      t.integer :total_critical, null: false, default: 0
      t.integer :total_major, null: false, default: 0
      t.integer :total_minor, null: false, default: 0
      t.integer :position

      t.timestamps
    end

    add_index :refinery_quality_assurance_inspections, :company_id, name: 'index_qa_inspections_on_company_id'
    add_index :refinery_quality_assurance_inspections, :supplier_id, name: 'index_qa_inspections_on_supplier_id'
    add_index :refinery_quality_assurance_inspections, :business_section_id, name: 'index_qa_inspections_on_business_section_id'
    add_index :refinery_quality_assurance_inspections, :business_product_id, name: 'index_qa_inspections_on_business_product_id'
    add_index :refinery_quality_assurance_inspections, :assigned_to_id, name: 'index_qa_inspections_on_assigned_to_id'
    add_index :refinery_quality_assurance_inspections, :resource_id, name: 'index_qa_inspections_on_resource_id'
    add_index :refinery_quality_assurance_inspections, :document_id, name: 'index_qa_inspections_on_document_id'
    add_index :refinery_quality_assurance_inspections, :result, name: 'index_qa_inspections_on_result'
    add_index :refinery_quality_assurance_inspections, :inspection_date, name: 'index_qa_inspections_on_inspection_date'
    add_index :refinery_quality_assurance_inspections, :inspection_type, name: 'index_qa_inspections_on_inspection_type'
    add_index :refinery_quality_assurance_inspections, :po_number, name: 'index_qa_inspections_on_po_number'
    add_index :refinery_quality_assurance_inspections, :po_type, name: 'index_qa_inspections_on_po_type'
    add_index :refinery_quality_assurance_inspections, :po_qty, name: 'index_qa_inspections_on_po_qty'
    add_index :refinery_quality_assurance_inspections, :product_code, name: 'index_qa_inspections_on_product_code'
    add_index :refinery_quality_assurance_inspections, :product_description, name: 'index_qa_inspections_on_product_description'
    add_index :refinery_quality_assurance_inspections, :position, name: 'index_qa_inspections_on_position'
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-quality_assurance"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/quality_assurance"})
    end

    drop_table :refinery_quality_assurance_inspections

  end

end
