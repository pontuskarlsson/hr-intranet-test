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

      def charge_valid?(charge)
        @validation_block.nil? || @validation_block.call(charge)
      end

    end
  end
end

Refinery::Business::Discount.register 'SS20PROMO', percentage: -0.5 do |validate_charge|
  # Only allow to double up to 10 days, which equals 20 total days and must be
  # an even number since the base qty is doubled.
  validate_charge.qty <= 20 &&
      validate_charge.qty.to_i == validate_charge.qty &&
      validate_charge.qty.to_i.even?
end