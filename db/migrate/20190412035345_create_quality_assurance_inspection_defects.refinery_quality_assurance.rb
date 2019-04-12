# This migration comes from refinery_quality_assurance (originally 3)
class CreateQualityAssuranceInspectionDefects < ActiveRecord::Migration
  def change
    create_table :refinery_quality_assurance_inspection_defects do |t|
      t.integer :inspection_id
      t.integer :defect_id
      t.integer :critical, null: false, default: 0
      t.integer :major, null: false, default: 0
      t.integer :minor, null: false, default: 0
      t.string :comments

      t.timestamps
    end

    add_index :refinery_quality_assurance_inspection_defects, :inspection_id, name: 'index_qa_inspection_defects_on_inspection_id'
    add_index :refinery_quality_assurance_inspection_defects, :defect_id, name: 'index_qa_inspection_defects_on_defect_id'
  end
end
