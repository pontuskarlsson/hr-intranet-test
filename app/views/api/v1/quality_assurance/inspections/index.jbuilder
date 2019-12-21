json.array! @inspections.includes(:inspection_defects, :inspection_photos, :resource) do |inspection|
  inspection.to_builder json
end
