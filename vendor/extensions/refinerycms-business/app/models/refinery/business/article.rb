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

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_enumerables :managed_status, MANAGED_STATUSES
      configure_label :code

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

    end
  end
end
