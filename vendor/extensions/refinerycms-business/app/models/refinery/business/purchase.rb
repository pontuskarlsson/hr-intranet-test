module Refinery
  module Business
    class Purchase < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_purchases'

      STATUSES = %w(created paid failed)

      PROMO_MAX_DOUBLE_QTY = 10



      store :meta, accessors: [:article_code, :qty, :webhook_object, :card_object]

      delegate :name, :description, :sales_unit_price, to: :article, prefix: true, allow_nil: true

      belongs_to :user,     class_name: 'Refinery::Authentication::Devise::User'
      belongs_to :company,  class_name: 'Refinery::Business::Company'
      belongs_to :invoice,  class_name: 'Refinery::Business::Invoice', optional: true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:article_code, :status]

      configure_enumerables :status, STATUSES

      responds_to_data_tables :id, :created_at, :status, :total_cost, methods: [:article_code, :article_description]

      validates :user_id, presence: true
      validates :company_id, presence: true
      validates :status,  inclusion: STATUSES
      validates :stripe_checkout_session_id, uniqueness: true, allow_blank: true
      validates :stripe_payment_intent_id, uniqueness: true, allow_blank: true
      validates :stripe_event_id, uniqueness: true, allow_blank: true
      validates :stripe_charge_id, uniqueness: true, allow_blank: true
      validates :sub_total_cost, numericality: { greater_than: 0 }
      validates :total_discount, numericality: { less_than_or_equal_to: 0 }
      validates :total_cost, numericality: { greater_than_or_equal_to: 0 }
      validates :qty, numericality: { greater_than: 0, only_integer: true }

      validate do
        if discount_code.present?
          if discount.present?
            charges.each { |charge| discount.validate_charge(charge, errors) }
          else
            errors.add(:discount_code, 'is not a valid code')
          end
        end
        errors.add(:article_code, 'is not a valid article') unless article&.is_voucher
      end

      before_validation do
        self.status ||= 'created'
        calculate_cost!

        if company_id.nil? && user.present?
          self.company_id = user.companies.first.id if user.companies.count == 1
        end
      end

      def article
        @article ||= Article.find_by code: article_code
      end

      def qty
        super&.to_i || 0
      end

      def calculate_cost!
        self.sub_total_cost = article.present? ? qty * article_sales_unit_price : 0.0

        self.total_discount = discount.present? ? sub_total_cost * discount.percentage : 0.0
        self.total_cost = sub_total_cost + total_discount
      end

      def discount
        @discount ||= discount_code.present? ? Discount.by_promo(discount_code) : Discount.base_discount_for(qty)
      end

      def discount_amount
        if discount.present?
          discount.percentage * article_sales_unit_price
        else
          0.0
        end
      end

      def charges
        @charges ||= [
            Charge.new(
                qty,
                article_code,
                article_sales_unit_price,
                discount_amount,
                'fixed_amount',
                { 'promo' => discount_code }
            )
        ]
      end

      def card_last4
        card_object && card_object['last4']
      end

      def card_brand
        card_object && card_object['brand']&.titlecase
      end

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

      def happy_rabbit_reference_id
        "hr_stripe_#{id}" if persisted?
      end

      def self.find_by_happy_rabbit_reference_id!(ref_id)
        find ref_id.gsub('hr_stripe_', '')
      end

    end
  end
end
