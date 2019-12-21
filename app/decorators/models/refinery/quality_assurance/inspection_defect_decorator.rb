Refinery::QualityAssurance::InspectionDefect.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  def to_builder(json)
    json.(self, :id, :defect_id, :inspection_id)
    json.(self, :critical, :major, :minor, :comments, :defect_label, :can_fix)

    json.(self, :created_at, :updated_at)
  end

end
