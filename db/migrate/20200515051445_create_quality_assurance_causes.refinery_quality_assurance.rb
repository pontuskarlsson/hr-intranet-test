# This migration comes from refinery_quality_assurance (originally 12)
class CreateQualityAssuranceCauses < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_quality_assurance_causes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.integer :category_code
      t.string :category_name
      t.integer :cause_code
      t.string :cause_name
      t.string :code
      t.text :description

      t.jsonb :block
      t.jsonb :block_versions

      t.timestamps
    end

    add_index :refinery_quality_assurance_causes, :category_code
    add_index :refinery_quality_assurance_causes, :category_name
    add_index :refinery_quality_assurance_causes, :cause_code
    add_index :refinery_quality_assurance_causes, :cause_name
    add_index :refinery_quality_assurance_causes, :code
  end

end
