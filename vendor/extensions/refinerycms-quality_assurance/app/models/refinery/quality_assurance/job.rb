module Refinery
  module QualityAssurance
    class Job < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_jobs'

      STATUSES = %w(Draft Confirmed Scheduled Completed Invoiced)
      JOB_TYPES = %w(Inspection)
      BILLABLE_TYPES = %w(ManDay)

      belongs_to :assigned_to,      class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :company,          class_name: '::Refinery::Business::Company'
      belongs_to :project,          class_name: '::Refinery::Business::Project'
      belongs_to :section,          class_name: '::Refinery::Business::Section'
      belongs_to :billable,         class_name: '::Refinery::Business::Billable'
      belongs_to :visit
      has_one :inspection,          dependent: :nullify

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:code, :title, :description, :company_code, :company_label, :assigned_to_label]

      #validates :company_id,        presence: true # Remove validation since some inspections from external might not be able to match company name initially
      validates :status,            inclusion: STATUSES
      validates :job_type,          inclusion: JOB_TYPES
      validates :billable_type,     inclusion: BILLABLE_TYPES

      validate do
        if project.present?
          errors.add(:project_id, 'cannot use project from another company') unless project.company_id == company_id
        end
        if section.present?
          errors.add(:section_id, 'cannot use section from another project') unless section.project_id == project_id
        end
        if billable.present?
          errors.add(:billable_id, 'cannot use billable from another company') unless billable.company_id == company_id
        end
      end

      before_validation(on: :create) do
        self.status ||= 'Draft'
        assign_code!
      end

      before_validation do
        if project.present?
          self.section ||= project.sections.find_or_create_by!(section_type: 'QA') { |section|
            section.description = "Inspections #{project.description}"
          }
        end
      end

      before_save do
        if company.present?
          self.company_code = company.code
          self.company_label = company.name

          if billable.nil?
            self.billable =
                if (job = company.jobs.billable_with(self).first).present?
                  job.billable
                else
                  company.billables.create!(
                      billable_type: 'time',
                      project_id: project_id,
                      section_id: section_id,
                      title: "QA Jobs on #{inspection_date} by #{assigned_to_label}",
                      qty: 1,
                      qty_unit: 'day',
                      unit_price: 350,
                      article_code: 'TBC'
                  )
                end
          end
        end
        if project.present?
          self.company_project_reference = project.company_reference
          self.project_code = project.code
        end
        if assigned_to.present?
          self.assigned_to_label = assigned_to.full_name
        end

      end

      after_save do
        if billable.present?
          billable.project ||= project
          billable.section ||= section
          billable.title = "QA Jobs on #{inspection_date} by #{assigned_to_label}"
          billable.save!
        end
      end

      scope :billable_with, -> (job) {
        where.not(billable_id: nil).
            where.not(id: job.id).
            where(assigned_to_label: job.assigned_to_label, inspection_date: job.inspection_date, company_id: job.company_id)
      }

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        self.project = ::Refinery::Business::Project.find_by_label label
        @project_label = label
      end

      def assign_code!
        # if code.blank?
        #   self.code = ::Refinery::Business::NumberSerie.next_counter!(::Refinery::QualityAssurance::Inspection, :code, prefix: 'QA-', pad_length: 6)
        # end
      end

    end
  end
end
