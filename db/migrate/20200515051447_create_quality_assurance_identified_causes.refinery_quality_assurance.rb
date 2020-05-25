# This migration comes from refinery_quality_assurance (originally 14)
class CreateQualityAssuranceIdentifiedCauses < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_quality_assurance_identified_causes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :cause, type: :uuid, foreign_key: { to_table: :refinery_quality_assurance_causes }, index: { name: 'INDEX_qa_identified_causes_ON_cause_id' }
      t.references :inspection_defect, foreign_key: { to_table: :refinery_quality_assurance_inspection_defects }, index: { name: 'INDEX_qa_identified_causes_ON_inspection_defect_id' }
      t.text :details

      t.jsonb :analytics

      t.timestamps
    end
  end

end
