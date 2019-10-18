module Refinery
  module Shipping
    class Route < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_routes'

      TYPES = %w(origin port_of_loading port_of_discharge destination custom)
      STATUS = %w(not_departed departed not_arrived arrived)

      belongs_to :shipment
      belongs_to :location
      belongs_to :prior_route,    class_name: '::Refinery::Shipping::Route'

      delegate :label, :description, :lat, :lng, :airport, :seaport, :railport, :roadport,
               :street1, :street2, :city, :postal_code, :state, :country, :country_code,
               to: :location, prefix: true, allow_nil: true

      validates :shipment_id,           presence: true
      validates :location_id,           presence: true, uniqueness: { scope: :shipment_id }
      validates :route_type,            inclusion: TYPES
      validates :status,                inclusion: STATUS
      #validates :final_destination,     uniqueness: true, if: -> { final_destination }

      validate do
        if prior_route.present?
          errors.add(:prior_route_id, :invalid) unless prior_route.shipment_id == shipment_id
        end
      end

      before_validation(on: :create) do
        self.status ||= route_type == 'origin' ? 'not_departed' : 'not_arrived'
      end

      before_save do
        self.final_destination = route_type == 'destination'
        true # Do not halt by returning false
      end

      def has_arrived?
        arrived_at.present? && arrived_at < DateTime.now
      end

      def has_departed?
        departed_at.present? && departed_at < DateTime.now
      end

    end
  end
end
