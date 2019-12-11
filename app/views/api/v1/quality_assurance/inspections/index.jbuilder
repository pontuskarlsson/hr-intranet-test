json.array! @inspections.includes(:inspection_defects) do |inspection|
  json.(inspection, :id, :job_id, :code)
  json.(inspection, :company_id, :company_label, :company_code)
  json.(inspection, :supplier_id, :supplier_label, :supplier_code)
  json.(inspection, :manufacturer_id, :manufacturer_label, :manufacturer_code)
  json.(inspection, :inspected_by_id, :inspected_by_label)
  json.(inspection, :project_code, :company_project_reference)

  json.(inspection, :result, :inspection_date, :status)

  json.(inspection, :po_number, :po_type, :po_qty, :available_qty)
  json.(inspection, :product_code, :product_description, :product_colour_variants)

  json.(inspection, :inspection_type, :inspection_standard, :inspection_sample_size)
  json.(inspection, :acc_critical, :acc_major, :acc_minor, :total_critical, :total_major, :total_minor)

  json.defects inspection.inspection_defects do |inspection_defect|
    json.(inspection_defect, :id, :defect_id, :inspection_id)
    json.(inspection_defect, :critical, :major, :minor, :comments, :defect_label, :can_fix)
  end
end
