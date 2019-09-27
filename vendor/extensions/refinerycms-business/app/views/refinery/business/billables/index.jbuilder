billables = @billables.includes(:company, :invoice)

json.data billables do |billable|
  json.(billable, :id, :company_label, :title, :billable_date, :assigned_to_label)
  json.(billable, :article_code, :invoice_invoice_number, :qty, :qty_unit, :unit_price)
  json.(billable, :discount, :total_cost, :status)
end
