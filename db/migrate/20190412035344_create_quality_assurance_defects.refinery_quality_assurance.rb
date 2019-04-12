# This migration comes from refinery_quality_assurance (originally 2)
class CreateQualityAssuranceDefects < ActiveRecord::Migration
  def change
    create_table :refinery_quality_assurance_defects do |t|
      t.integer :category_code
      t.string :category_name
      t.integer :defect_code
      t.string :defect_name

      t.integer :position

      t.timestamps
    end

    add_index :refinery_quality_assurance_defects, :category_code, name: 'index_qa_defects_on_category_code'
    add_index :refinery_quality_assurance_defects, :category_name, name: 'index_qa_defects_on_category_name'
    add_index :refinery_quality_assurance_defects, :defect_code, name: 'index_qa_defects_on_defect_code'
    add_index :refinery_quality_assurance_defects, :defect_name, name: 'index_qa_defects_on_defect_name'
  end
end
