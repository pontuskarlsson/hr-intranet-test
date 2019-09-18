Refinery::Business::Billable.class_eval do

  # Associations
  has_many :quality_assurance_jobs,     class_name: '::Refinery::QualityAssurance::Job',
                                        dependent: :nullify

end
