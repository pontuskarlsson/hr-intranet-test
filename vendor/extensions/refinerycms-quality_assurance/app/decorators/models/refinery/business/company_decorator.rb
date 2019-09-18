Refinery::Business::Company.class_eval do

  # Associations
  has_many :inspections,            class_name: '::Refinery::QualityAssurance::Inspection',
                                    dependent: :nullify
  has_many :supplier_inspections,   class_name: '::Refinery::QualityAssurance::Inspection',
                                    foreign_key: :supplier_id,
                                    dependent: :nullify
  has_many :jobs,                   class_name: '::Refinery::QualityAssurance::Job',
                                    dependent: :nullify

end
