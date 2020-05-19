module Refinery
  module Business
    class Discount

      def self.register(promo_code, options = {}, &validation_block)
        @discounts ||= []
        @discounts << new(options.merge(promo_code: promo_code, validation_block: validation_block))
      end

      def self.by_promo(promo_code)
        @discounts.detect { |discount| discount.promo_code == promo_code }
      end

      def self.base_discount_for(qty)
        return if qty.nil?

        if qty >= 10
          new(percentage: -0.04)
        elsif qty >= 5
          new(percentage: -0.02)
        end
      end

      attr_reader :promo_code, :percentage

      def initialize(options)
        @options = options
        @promo_code = options[:promo_code]
        @percentage = options[:percentage]
        @validation_block = options[:validation_block]
      end

      def validate_charge(charge, errors)
        if @validation_block.present?
          @validation_block.call(charge, errors)
        end
      end

    end
  end
end

Refinery::Business::Discount.register 'SS20PROMO', percentage: -0.5 do |validate_charge, errors|
  # Only allow to double up to 10 days, which equals 20 total days and must be
  # an even number since the base qty is doubled.
  if validate_charge.qty > 20
    errors.add(:discount_code, 'can only be used to buy up to 20 Mandays')
  end

  if validate_charge.qty.to_i != validate_charge.qty
    errors.add(:discount_code, 'cannot be used to buy partial Mandays')
  end

  if validate_charge.qty.to_i.odd?
    errors.add(:discount_code, 'is a 2-for-1 promotion and cannot result in an odd qty')
  end
end