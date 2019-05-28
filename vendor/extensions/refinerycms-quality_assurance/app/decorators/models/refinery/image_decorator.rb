Refinery::Image.class_eval do

  # Associations
  has_one :inspection_photo, class_name: '::Refinery::QualityAssurance::InspectionPhoto', dependent: :nullify

end
