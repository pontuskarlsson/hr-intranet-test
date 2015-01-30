require 'active_support/concern'

module Refinery
  module Store
    module UserAddon
      extend ActiveSupport::Concern

      included do
        has_many :store_orders, class_name: '::Refinery::Store::Order', dependent: :destroy
      end

      def cart_count
        $redis.scard "cart#{id}"
      end

    end
  end
end
