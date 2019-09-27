billables = @billables.includes(:company, :invoice)

json.data billables do |billable|
  json.(billable, :id, :company_label, :invoice_invoice_number)
  json.(billable, :title, :total_cost, :billable_date)
end
