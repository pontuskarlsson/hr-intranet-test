module Refinery
  module Business
    class Section < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_sections'

      class_attribute :registered_jobs

      TYPES = %w(VBO QA)

      belongs_to :project, optional: true
      has_many :sections, dependent: :destroy
      #has_many :billables, dependent: :nullify

      configure_assign_by_label :project, class_name: '::Refinery::Business::Project'
      configure_label :description

      validates :project_id,    presence: true
      validates :description,   presence: true
      validates :section_type,  inclusion: TYPES, uniqueness: { scope: :project_id }
      validates :start_date,    presence: true

      before_validation do
        self.start_date ||= project.try(:start_date)
      end

      validate do
        if project.present?
          if start_date.present? && project.start_date > start_date
            errors.add(:start_date, 'cannot be earlier than project start')
          end
        end
      end

      def jobs_and_allocations
        @jobs_and_allocations ||= all_jobs { |job_scope| job_scope.includes(billable: { quality_assurance_jobs: :inspection, invoice: {} }) }.each_with_object({}) { |job, acc|
          acc[job.billable] ||= { jobs: [] }
          acc[job.billable][:jobs] << job
        }.to_a.sort_by{ |(billable, _)| billable.billable_date }.to_h
      end

      def all_jobs(&block)
        (registered_jobs || {}).keys.inject([]) do |acc, assoc_name|
          res =
              if block_given?
                yield send(assoc_name)
              else
                send(assoc_name)
              end
          acc.concat res
        end
      end

      def self.register_job(klass, assoc_name, options = {})
        self.registered_jobs ||= {}
        registered_jobs[assoc_name] = options.merge(class_name: klass.name)

        has_many assoc_name, class_name: klass.name, dependent: :nullify
      end

      def all_job_association_names
        registered_jobs.keys
      end

    end
  end
end
