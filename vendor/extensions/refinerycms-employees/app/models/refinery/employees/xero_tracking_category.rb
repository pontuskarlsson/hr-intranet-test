module Refinery
  module Employees
    class XeroTrackingCategory < Refinery::Core::BaseModel
      STATUS_ACTIVE = 'ACTIVE'
      STATUS_ARCHIVED = 'ARCHIVED'
      STATUSES = [STATUS_ACTIVE, STATUS_ARCHIVED]

      self.table_name = 'refinery_xero_tracking_categories'

      serialize :options, Array

      attr_accessible :name, :status, :guid, :options

      validates :guid,    presence: true, uniqueness: true
      validates :name,    presence: true
      validates :status,  inclusion: STATUSES

      validate do
        # Note about status, there can only be two Active categories at the same time.
        if status == STATUS_ACTIVE
          scope = XeroTrackingCategory.where(status: STATUS_ACTIVE)
          scope = scope.where('id <> ?', id) if persisted?
          errors.add(:status, 'too many active Categories') if scope.count > 1
        end
      end

      validate do
        option_guids = options.map { |o| o[:guid] }
        if option_guids.length != option_guids.uniq.length
          errors.add(:options, 'duplicate guids in Options')
        end
      end

      class << self
        def active
          where(status: STATUS_ACTIVE)
        end

        def archived
          where(status: STATUS_ARCHIVED)
        end

      end
    end
  end
end
