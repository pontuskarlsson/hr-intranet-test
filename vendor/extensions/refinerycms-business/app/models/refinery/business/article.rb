module Refinery
  module Business
    class Article < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_articles'

      MANAGED_STATUSES = %w(draft submitted changed)

      serialize :voucher_constraint, Hash

      belongs_to :account
      belongs_to :company
      has_many :billables,        dependent: :nullify

      acts_as_indexed :fields => [:code, :name, :description]

      #validates :account_id,      presence: true
      validates :item_id,         uniqueness: true, allow_blank: true
      validates :code,            presence: true, uniqueness: { scope: [:account_id] }
      validates :managed_status,  inclusion: MANAGED_STATUSES, allow_nil: true
      validates :managed_status,  presence: true, if: -> { is_managed }

      scope :is_public, -> { where(is_public: true) }
      scope :non_voucher, -> { where(is_voucher: false) }
      scope :voucher, -> { where(is_voucher: true) }

      validate do
        if company.present?
          errors.add(:is_public, 'cannot be public when company is present') if is_public
        end
      end

      def label
        code
      end

      def self.find_by_label(label)
        find_by code: label
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
      end

      def voucher_constraint_applicable_articles
        self.voucher_constraint ||= {}
        Array(voucher_constraint['applicable_articles']).join(', ')
      end

      def voucher_constraint_applicable_articles=(applicable_articles)
        self.voucher_constraint ||= {}
        if applicable_articles.is_a? Array
          voucher_constraint['applicable_articles'] = applicable_articles

        elsif applicable_articles.is_a? String
          voucher_constraint['applicable_articles'] = applicable_articles.split(',').map(&:squish)
        end

        applicable_articles
      end

      def applicable_to?(article_code)
        voucher_constraint_applicable_articles.include? article_code
      end

      def display_managed_status
        if managed_status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.managed_statuses.#{managed_status}"
        end
      end

      def self.managed_status_options
        MANAGED_STATUSES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.managed_statuses.#{k}"),k] }
      end

      MANAGED_STATUSES.each do |ms|
        define_method :"managed_status_is_#{ms}?" do
          managed_status == ms
        end
      end

      def self.to_source
        where(nil).pluck(:code).to_json.html_safe
      end

    end
  end
end
