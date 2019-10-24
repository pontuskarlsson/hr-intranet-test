inspections = @inspections.includes(inspection_defects: :defect, inspection_photo: :image).order(inspection_date: :desc)

json.data inspections do |inspection|
  json.(inspection, :id, :code, :company_label, :supplier_label, :manufacturer_label, :inspection_date, :inspection_type, :result, :po_number, :po_qty, :company_project_reference, :project_code, :po_qty, :available_qty, :inspection_sample_size, :inspected_by_name, :product_code, :product_description, :product_colour_variants)
  json.(inspection, :product_label, :chart_defects, :inspection_photo_image_url, :inspection_photo_preview_url, :inspection_photo_thumb_url)
  json.(inspection, :status) if page_role?(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER)
end
