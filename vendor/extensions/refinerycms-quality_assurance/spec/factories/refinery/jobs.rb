FactoryBot.define do
  factory :job, :class => Refinery::QualityAssurance::Job do
    association :company, factory: :verified_company

    status { 'Draft' }
    job_type { 'Inspection' }
    billable_type { 'ManDay' }
  end
end
