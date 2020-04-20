module Refinery
  module Business
    class PurchaseForm < ApplicationTransForm

      set_main_model :purchase, class_name: '::Refinery::Business::Purchase', proxy: { attributes: %w(qty discount_code) }

      attribute :article_code,    String, default: proc { |f| f.purchase&.article_code }
      attribute :qty,             Integer, default: proc { |f| f.purchase&.qty }

      attr_accessor :company

      delegate :total_cost, :sub_total_cost, :total_discount, to: :purchase, allow_nil: true
      delegate :sales_unit_price, :name, :description, to: :article, prefix: true, allow_nil: true

      validates :company,     presence: true

      def model=(model)
        if model.is_a?(Refinery::Business::Company)
          self.purchase = model.purchases.build
          self.company = model
        else
          self.company = model&.company
          self.purchase = model
        end
      end

      def discount
        @discount ||= discount_code.present? ? Discount.by_promo(discount_code) : Discount.base_discount_for(qty)
      end

      def article
        @article ||= Article.find_by code: article_code
      end

      def discount_double?
        discount&.percentage == -0.5
      end

      def default_qty
        discount_double? ? 2 : 1
      end

      def max_qty
        discount_double? ? 20 : nil
      end

      def step_qty
        discount_double? ? 2 : 1
      end

      transaction do
        purchase.user = current_user
        purchase.attributes = purchase_params
        purchase.save!

        trigger_stripe_payment!
      end

      private

      def purchase_params(allowed = %i(qty article_code discount_code))
        attributes.slice(*allowed)
      end

      def trigger_stripe_payment!
        purchase.stripe_checkout_session_id = Stripe::Checkout::Session.create({
            success_url: ::Refinery::Business.config.stripe_success_url,
            cancel_url: ::Refinery::Business.config.stripe_cancel_url,
            payment_method_types: ['card'],
            mode: 'payment',
            customer_email: purchase.user&.email,
            client_reference_id: purchase.happy_rabbit_reference_id,
            line_items: [
                {
                    name: article_name,
                    description: article_description,
                    amount: (total_cost / qty * 100).to_i,
                    currency: 'usd',
                    quantity: qty,
                },
            ],
        }).id
        purchase.save!
      end

    end
  end
end
