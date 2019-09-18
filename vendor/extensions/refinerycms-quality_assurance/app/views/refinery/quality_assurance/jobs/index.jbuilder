json.data @jobs do |job|
  json.(job, :id, :code, :company_label, :project_code, :status, :inspection_date)
end
