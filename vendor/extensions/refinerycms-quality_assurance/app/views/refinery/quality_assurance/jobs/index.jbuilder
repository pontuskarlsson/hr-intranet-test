json.data @jobs do |job|
  json.(job, :id, :code, :company_label, :project_code, :company_project_reference, :title, :description, :job_type, :assigned_to_label, :status, :inspection_date)
end
