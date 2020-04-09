module Refinery
  module Business
    class Purchase < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_purchases'

      STATUSES = %w(created paid failed)

      store :meta, accessors: [:article_code, :qty, :webhook_object]

      delegate :name, :description, :sales_unit_price, to: :article, prefix: true, allow_nil: true

      belongs_to :user,     class_name: 'Refinery::Authentication::Devise::User'
      belongs_to :company,  class_name: 'Refinery::Business::Company'
      belongs_to :invoice,  class_name: 'Refinery::Business::Invoice'

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
      validates :sub_total_cost, numericality: { greater_than: 0 }
      validates :total_discount, numericality: { less_than_or_equal_to: 0 }
      validates :total_cost, numericality: { greater_than_or_equal_to: 0 }
      validates :qty, numericality: { greater_than: 0, only_integer: true }

      before_validation do
        self.status ||= 'created'
        calculate_cost

        if company_id.nil? && user.present?
          self.company_id = user.companies.first.id if user.companies.count == 1
        end
      end

      after_create do
        session = Stripe::Checkout::Session.create({
            success_url: ::Refinery::Business.config.stripe_success_url,
            cancel_url: ::Refinery::Business.config.stripe_cancel_url,
            payment_method_types: ['card'],
            mode: 'payment',
            customer_email: user.email,
            client_reference_id: happy_rabbit_reference_id,
            line_items: [
                {
                    name: article_name,
                    description: article_description,
                    amount: (total_cost / qty.to_i * 100).to_i,
                    currency: 'usd',
                    quantity: qty.to_i,
                },
            ],
        })

        self.stripe_checkout_session_id = session.id
        throw :abort unless save
      end

      validate do
        errors.add(:discount_code, :invalid) if discount_code.present? && discount_code.downcase != 'ss20promo'
        errors.add(:article_code, :invalid) unless article&.is_voucher
      end

      def article
        @article ||= Article.find_by code: article_code
      end

      def calculate_cost
        quantity = (self.qty.presence.to_i || 0)

        self.sub_total_cost = article.present? ? quantity * article_sales_unit_price : 0.0

        if quantity >= 10
          self.total_discount = sub_total_cost * -0.04
        elsif quantity >= 5
          self.total_discount = sub_total_cost * -0.02
        else
          0.0
        end

        self.total_cost = sub_total_cost + total_discount
      end

      def discount_double?
        discount_code&.downcase == 'ss20promo'
      end

      def no_of_credits
        if discount_double?
          qty.to_i + [qty.to_i, 10].min
        else
          qty.to_i
        end
      end

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
