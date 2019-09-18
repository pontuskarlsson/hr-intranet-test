billables = @billables.includes(:company, :project, :invoice)

json.data billables do |billable|
  json.(billable, :id, :company_label, :project_label, :invoice_invoice_number)
  json.(billable, :title, :total_cost)
end
