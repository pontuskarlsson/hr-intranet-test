# This migration comes from refinery_quality_assurance (originally 11)
class CreateQualityAssuranceJobs < ActiveRecord::Migration

  def change
    create_table :refinery_quality_assurance_jobs do |t|

      ### Attribute for all Billable ###
      t.integer  :company_id
      t.string   :company_code
      t.string   :company_label

      t.integer  :project_id
      t.string   :project_code
      t.string   :company_project_reference
      t.integer  :section_id

      t.string   :billable_type
      t.integer  :billable_id
      t.string   :status


      ### Attributes to standardise the presentation data of a job ###
      t.string   :code
      t.string   :title
      t.text     :description


      ### Attributes for all QA Jobs ###
      t.integer  :assigned_to_id
      t.string   :assigned_to_label

      t.string :job_type
      t.date :inspection_date
      t.decimal  :time_spent, precision: 8, scale: 2, null: false, default: 0
      t.text :time_log

      t.integer :position

      t.timestamps
    end

    add_index :refinery_quality_assurance_jobs, :company_id, name: 'index_qa_inspection_jobs_on_company_id'
    add_index :refinery_quality_assurance_jobs, :company_code, name: 'index_qa_inspection_jobs_on_company_code'
    add_index :refinery_quality_assurance_jobs, :company_label, name: 'index_qa_inspection_jobs_on_company_label'

    add_index :refinery_quality_assurance_jobs, :project_id, name: 'index_qa_inspection_jobs_on_project_id'
    add_index :refinery_quality_assurance_jobs, :project_code, name: 'index_qa_inspection_jobs_on_project_code'
    add_index :refinery_quality_assurance_jobs, :company_project_reference, name: 'index_qa_inspection_jobs_on_company_project_reference'
    add_index :refinery_quality_assurance_jobs, :section_id, name: 'index_qa_inspection_jobs_on_section_id'

    add_index :refinery_quality_assurance_jobs, :billable_type, name: 'index_qa_inspection_jobs_on_billable_type'
    add_index :refinery_quality_assurance_jobs, :billable_id, name: 'index_qa_inspection_jobs_on_billable_id'
    add_index :refinery_quality_assurance_jobs, :status, name: 'index_qa_inspection_jobs_on_status'

    add_index :refinery_quality_assurance_jobs, :code, name: 'index_qa_inspection_jobs_on_code'
    add_index :refinery_quality_assurance_jobs, :title, name: 'index_qa_inspection_jobs_on_title'

    add_index :refinery_quality_assurance_jobs, :assigned_to_id, name: 'index_qa_inspection_jobs_on_assigned_to_id'
    add_index :refinery_quality_assurance_jobs, :assigned_to_label, name: 'index_qa_inspection_jobs_on_assigned_to_label'

    add_index :refinery_quality_assurance_jobs, :job_type, name: 'index_qa_inspection_jobs_on_job_type'
    add_index :refinery_quality_assurance_jobs, :inspection_date, name: 'index_qa_inspection_jobs_on_inspection_date'

    add_index :refinery_quality_assurance_jobs, :position, name: 'index_qa_inspection_jobs_on_position'

    # Add column to Inspection to connect with the Job
    add_column :refinery_quality_assurance_inspections, :job_id, :integer
    add_index :refinery_quality_assurance_inspections, :job_id, name: 'index_qa_inspections_on_job_id'
  end

end
