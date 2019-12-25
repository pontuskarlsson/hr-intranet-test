billables = @billables.where('billable_date >= :start AND billable_date < :end', calendar_params)

json.array! billables do |billable|
  json.(billable, :id, :billable_date, :assigned_to_label, :company_label, :manufacturer_label)
end
