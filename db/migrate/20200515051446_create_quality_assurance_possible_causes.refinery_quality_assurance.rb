# This migration comes from refinery_quality_assurance (originally 13)
class CreateQualityAssurancePossibleCauses < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_quality_assurance_possible_causes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :cause, type: :uuid, foreign_key: { to_table: :refinery_quality_assurance_causes }, index: { name: 'INDEX_qa_possible_causes_ON_cause_id' }
      t.references :defect, foreign_key: { to_table: :refinery_quality_assurance_defects }, index: { name: 'INDEX_qa_possible_causes_ON_defect_id' }

      t.jsonb :analytics

      t.timestamps
    end
  end

end
