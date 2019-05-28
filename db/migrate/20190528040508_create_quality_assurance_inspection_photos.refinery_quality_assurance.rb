# This migration comes from refinery_quality_assurance (originally 4)
class CreateQualityAssuranceInspectionPhotos < ActiveRecord::Migration
  def change
    create_table :refinery_quality_assurance_inspection_photos do |t|
      t.integer :inspection_id
      t.integer :inspection_defect_id
      t.integer :image_id
      t.string :file_id
      t.text :fields

      t.timestamps
    end

    add_index :refinery_quality_assurance_inspection_photos, :inspection_id, name: 'index_qa_inspection_photos_on_inspection_id'
    add_index :refinery_quality_assurance_inspection_photos, :inspection_defect_id, name: 'index_qa_inspection_photos_on_inspection_defect_id'
    add_index :refinery_quality_assurance_inspection_photos, :image_id, name: 'index_qa_inspection_photos_on_image_id'
    add_index :refinery_quality_assurance_inspection_photos, :file_id, name: 'index_qa_inspection_photos_on_file_id'
  end
end
