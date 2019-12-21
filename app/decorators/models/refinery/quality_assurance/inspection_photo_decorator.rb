Refinery::QualityAssurance::InspectionPhoto.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  def to_builder(json)
    json.(self, :id, :inspection_id, :file_id, :inspection_defect_id)
    json.(self, :key)

    json.url self.expiring_url

    json.(self, :created_at, :updated_at)
  end

end
