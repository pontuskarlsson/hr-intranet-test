module Portal
  module Stripe
    class WebhookJob < Struct.new(:type, :data)

      # def enqueue(job)
      #
      # end

      def perform
        case type
        when 'checkout.session.completed' then perform_checkout_session
        else raise 'Unknown object'
        end
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        ErrorMailer.notification_email(["Portal::Stripe::WebhookJob #{job.id} has succeeded."]).deliver
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      def failure(job)
        ErrorMailer.notification_email(["Portal::Stripe::WebhookJob #{job.id} has failed after trying too many times unsuccessfully.", job.inspect]).deliver
      end

      private

      def perform_checkout_session
        ActiveRecord::Base.transaction do
          object = data['object']
          purchase = Purchase.find_by_happy_rabbit_reference_id! object['client_reference_id']
          purchase.status = 'paid'
          purchase.save!

          base_amount = purchase.sub_total_cost / purchase.qty.to_i
          discount_amount = purchase.total_discount / purchase.qty.to_i

          vouchers = purchase.no_of_credits.times.map do
            purchase.company.vouchers.create!(
                article: purchase.article,
                status: 'active',
                source: 'purchase',
                discount_type: 'fixed_amount',
                base_amount: base_amount,
                discount_amount: discount_amount,
                amount: base_amount + discount_amount,
                currency_code: 'usd',
                valid_from: purchase.created_at.to_date,
                valid_to: purchase.created_at.to_date + 1.year - 1.day
            )
          end
        end
      end

    end
  end
end
