module Refinery
  module Shipping
    class RoutesForm < ApplicationTransForm
      set_main_model :shipment

      attribute :routes_attributes, Hash

      delegate :persisted?, :routes, to: :shipment

      validates :shipment, presence: true

      transaction do
        each_nested_hash_for routes_attributes do |attr|
          update_route! attr
        end
      end

      protected

      def update_route!(attr, allowed = %w(route_type location_id arrived_at departed_at))
        if attr['id'].present?
          route = find_from! shipment.routes, attr['id']
          if attr['_destroy'] == '1'
            route.destroy
          else
            route.attributes = attr.slice(*allowed)
            route.prior_route = prior_route_for attr['route_type']
            route.save!
          end
        elsif (build_attr = attr.slice(*allowed)).values.any?(&:present?)
          route = shipment.routes.build(build_attr)
          route.prior_route = prior_route_for attr['route_type']
          route.save!
        end
      end

      def prior_route_for(route_type)
        types = ::Refinery::Shipping::Route::TYPES
        first = types.index(route_type) - 1

        # Mapping the route (if any) for each route_type, then returns the first present entry
        first.downto(0).map do |i|
          shipment.routes.detect { |d| d.persisted? && d.route_type == types[i] }
        end.compact.first
      end

    end
  end
end
