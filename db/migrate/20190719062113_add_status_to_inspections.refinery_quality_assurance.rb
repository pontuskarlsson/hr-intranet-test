# This migration comes from refinery_quality_assurance (originally 9)
class AddStatusToInspections < ActiveRecord::Migration
  def change
    add_column :refinery_quality_assurance_inspections, :status, :string
    add_index :refinery_quality_assurance_inspections, :status
  end
end
