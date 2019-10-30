module Refinery
  module Business
    class Article < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_articles'

      MANAGED_STATUSES = %w(draft synced changed)

      belongs_to :account
      belongs_to :company

      validates :account_id,      presence: true
      validates :item_id,         uniqueness: true, allow_blank: true
      validates :code,            uniqueness: { scope: [:account_id] }
      validates :managed_status,  inclusion: MANAGED_STATUSES, allow_nil: true

      def label
        code
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
      end

      def display_managed_status
        if managed_status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.managed_statuses.#{managed_status}"
        end
      end

      def self.managed_status_options
        MANAGED_STATUSES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{self.class.model_name.i18n_key}.managed_statuses.#{managed_status}"),k] }
      end

    end
  end
end
