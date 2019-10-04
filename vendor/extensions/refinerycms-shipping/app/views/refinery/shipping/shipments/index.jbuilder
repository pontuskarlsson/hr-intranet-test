json.data @shipments do |shipment|
  json.(shipment, :id, :code, :from_contact_label, :to_contact_label, :tracking_number, :mode)
  json.(shipment, :display_status, :etd_date, :eta_date, :shipment_terms, :courier_forwarder_company_label)
  json.(shipment, :archived_at)
end
