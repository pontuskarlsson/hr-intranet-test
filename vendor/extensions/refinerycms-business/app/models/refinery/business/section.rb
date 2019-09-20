module Refinery
  module Business
    class Section < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_sections'

      class_attribute :registered_jobs

      TYPES = %w(VBO QA)

      belongs_to :project
      has_many :sections, dependent: :destroy
      #has_many :billables, dependent: :nullify

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

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        @project_label = label
      end

      def label
        description
      end

      def jobs_and_allocations
        @jobs_and_allocations ||= all_jobs { |job_scope| job_scope.includes(billable: all_job_association_names) }.each_with_object({}) { |job, acc|
          acc[job.billable] ||= { jobs: [], total_no_of_jobs: job.billable.all_jobs.count }
          acc[job.billable][:jobs] << job
        }
      end

      def all_jobs(&block)
        registered_jobs.keys.inject([]) do |acc, assoc_name|
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
