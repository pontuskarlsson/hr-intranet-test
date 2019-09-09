inspections = @inspections.where('inspection_date >= :start AND inspection_date < :end', calendar_params)

json.array! inspections do |inspection|
  json.(inspection, :id, :inspection_date, :inspection_type, :company_label, :supplier_label, :manufacturer_label, :product_label, :inspected_by_name)
end
