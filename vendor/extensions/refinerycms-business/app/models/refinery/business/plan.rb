module Refinery
  module Business
    class Plan < Refinery::Core::BaseModel
      include ActionDispatch::Routing::RouteSet::MountedHelpers

      self.table_name = 'refinery_business_plans'

      STATUSES = %w(draft proposed confirmed rejected)

      belongs_to :account
      belongs_to :company
      belongs_to :confirmed_by,   class_name: '::Refinery::Authentication::Devise::User',
                                  optional: true
      belongs_to :notice_given_by,class_name: '::Refinery::Authentication::Devise::User',
                                  optional: true
      belongs_to :contact_person, class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :account_manager,class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :contract,       class_name: 'Document',
                                  optional: true

      acts_as_indexed :fields => [:reference, :title, :description]

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_assign_by_label :confirmed_by, class_name: '::Refinery::Authentication::Devise::User'
      configure_assign_by_label :notice_given_by, class_name: '::Refinery::Authentication::Devise::User'
      configure_assign_by_label :contact_person, class_name: '::Refinery::Authentication::Devise::User'
      configure_assign_by_label :account_manager, class_name: '::Refinery::Authentication::Devise::User'
      configure_enumerables :status, STATUSES

      configure_label :reference

      display_date_for :start_date, :end_date, :confirmed_at, :notice_given_at

      store :content, accessors: [ :plan_charges, :included_services ], coder: JSON, prefix: :plan

      delegate :full_name, to: :confirmed_by, prefix: true, allow_nil: true
      delegate :full_name, to: :contact_person, prefix: true, allow_nil: true
      delegate :full_name, to: :account_manager, prefix: true, allow_nil: true
      delegate :name, to: :company, prefix: true, allow_nil: true

      validates :company_id,      presence: true
      validates :reference,       presence: true, uniqueness: true
      validates :currency_code,   inclusion: ::Refinery::Business::Invoice::CURRENCY_CODES
      validates :status,          inclusion: STATUSES

      validate do
        if contract.present?
          errors.add(:contract_id, :invalid) unless contract.company_id == company_id
        end
        if contact_person.present?
          errors.add(:contact_person_id, :invalid) unless contact_person.company_ids.include? company_id
        end
        if account_manager.present?
          errors.add(:account_manager_id, :invalid) unless account_manager.has_role?(::Refinery::Business::ROLE_INTERNAL)
        end
      end

      before_validation do
        self.status = STATUSES.first if status.blank?

        if reference.blank?
          self.reference = NumberSerie.next_counter!(self.class, :reference, prefix: 'PL-')
        end
      end

      scope :non_draft, -> { where.not(status: 'draft') }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include? ROLE_INTERNAL
          where(nil)
        elsif titles.include? ROLE_EXTERNAL
          where(company_id: user.company_ids)
        else
          where('1=0')
        end
      end

      def charges
        @charges ||= Array(plan_charges).map { |mm|
          ::Refinery::Business::Invoice::Charge.new(*mm.values_at(:qty, :article_label, :base_amount, :discount_amount, :discount_type))
        }
      end

      def describe_contract_period
        <<~HEREDOC
          #{notice_period_months + min_contract_period_months}
          months including a
          #{notice_period_months}
          months notice period, i.e. notice can be given after
          #{min_contract_period_months}
          months.
        HEREDOC
      end

      def min_contract_value
        (notice_period_months + min_contract_period_months) * charges.reduce(0) { |acc, charge| acc + charge.total_amount  }
      end

      acts_as_notifiable :'refinery/authentication/devise/users',
                         targets: ->(inspection, key) {
                           # Disable automatic assignment for now and only use explicitly by calling
                           #
                           #  ActivityNotification::Notification.notify_all
                           #
                           Refinery::Authentication::Devise::User.where('1=0')
                         },
                         tracked: false, # no automatic callbacks
                         # group: :article,
                         # notifier: :user,
                         email_allowed: :is_email_allowed?

      def notifiable_path(target, key)
        refinery.business_plan_path(self)
      end

      def is_email_allowed?(target, key)
        ['plan.proposed', 'plan.confirmed'].include? key
      end

      def printable_name
        "#{reference} - #{title}"
      end

      def default_notification_key
        'plan.default'
      end

      def overriding_notification_email_subject(target, key)
        case key
        when 'plan.confirmed' then "Happy Rabbit Monthly Plan Confirmed!"
        when 'plan.proposed' then "Happy Rabbit Monthly Plan Proposed!"
        end
      end

    end
  end
end
