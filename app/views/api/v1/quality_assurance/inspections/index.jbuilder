json.array! @inspections.includes(:inspection_defects) do |inspection|
  inspection.to_builder json
end
