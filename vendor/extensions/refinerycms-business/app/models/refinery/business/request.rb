module Refinery
  module Business
    class Request < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_requests'

      REQUEST_TYPES = %w(inspection sourcing other)
      STATUSES = %w(draft requested resolved)

      belongs_to :company,              class_name: '::Refinery::Business::Company'
      belongs_to :created_by,           class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :requested_by,         class_name: '::Refinery::Authentication::Devise::User'
      has_many :documents,              class_name: '::Refinery::Business::Document'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:subject, :status, :request_type]

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_enumerables :request_type, REQUEST_TYPES
      configure_enumerables :status, STATUSES

      configure_label :code,  :subject

      has_comments
      serialize :zendesk_meta, Hash

      responds_to_data_tables :id, :subject, :code, :request_date, :status

      delegate :label, :full_name, :email, to: :created_by, prefix: true, allow_nil: true
      delegate :label, :full_name, :email, to: :requested_by, prefix: true, allow_nil: true

      validates :company_id,            presence: true
      validates :created_by_id,         presence: true
      validates :requested_by_id,       presence: true
      validates :participants,          presence: true
      validates :request_type,          inclusion: REQUEST_TYPES
      validates :status,                inclusion: STATUSES
      validates :subject,               presence: true
      validates :request_date,          presence: true

      before_validation do
        self.code = NumberSerie.next_counter!(self.class, :code, prefix: 'REQ') if code.blank?

        self.status = 'requested' if status.blank?
        self.participants ||= [created_by_id, requested_by_id].uniq.join(',')
        self.request_date ||= Date.today
      end

      scope :recent, -> (no_of_records = 10) { order(request_date: :desc).limit(no_of_records) }
      scope :requested, -> { where(status: 'requested') }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include? ROLE_INTERNAL
          where(nil)
        elsif titles.include? ROLE_EXTERNAL
          where(company_id: user.company_ids)
        else
          none
        end
      end

      def self.for_selected_company(selected_company)
        if selected_company.nil?
          where(nil)
        else
          where(company_id: selected_company.id)
        end
      end

      def self.from_params(params)
        active = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:active, true))
        archived = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:archived, true))

        if active && archived
          where(nil)
        elsif active
          where(archived_at: nil)
        elsif archived
          where.not(archived_at: nil)
        else
          none
        end
      end

      def submitter_email
        created_by_email
      end

      def submitter_full_name
        created_by_full_name
      end

      def requester_email
        requested_by_email
      end

      def requester_full_name
        requested_by_full_name
      end

    end
  end
end
