# This migration comes from refinery_quality_assurance (originally 9)
class AddStatusToInspections < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspections, :status, :string
    add_index :refinery_quality_assurance_inspections, :status

    add_column :refinery_quality_assurance_inspections, :product_category, :string
    add_index :refinery_quality_assurance_inspections, :product_category

    add_column :refinery_quality_assurance_inspections, :season, :string
    add_index :refinery_quality_assurance_inspections, :season

    add_column :refinery_quality_assurance_inspections, :brand_label, :string
    add_index :refinery_quality_assurance_inspections, :brand_label

    add_column :refinery_quality_assurance_inspections, :pps_available, :boolean
    add_index :refinery_quality_assurance_inspections, :pps_available

    add_column :refinery_quality_assurance_inspections, :pps_approved, :boolean
    add_index :refinery_quality_assurance_inspections, :pps_approved

    add_column :refinery_quality_assurance_inspections, :pps_comments, :text

    add_column :refinery_quality_assurance_inspections, :tp_available, :boolean
    add_index :refinery_quality_assurance_inspections, :tp_available

    add_column :refinery_quality_assurance_inspections, :tp_approved, :boolean
    add_index :refinery_quality_assurance_inspections, :tp_approved

    add_column :refinery_quality_assurance_inspections, :tp_comments, :text
  end
end
