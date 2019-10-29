module Refinery
  module Shipping
    class Route < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_routes'

      TYPES = %w(origin port_of_loading port_of_discharge destination custom)
      STATUS = %w(schedule_pending scheduled departed arrived)

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
        if route_type == 'origin'
          self.status ||= departed_at.present? ? 'scheduled' : 'schedule_pending'
        else
          self.status ||= arrived_at.present? ? 'scheduled' : 'schedule_pending'
        end
      end

      before_save do
        self.final_destination = route_type == 'destination'

        if status == 'schedule_pending'
          if departed_at.present? or arrived_at.present?
            self.status = 'scheduled'
          end
        end
      end

      def has_arrived?
        %w(departed arrived).include? status
      end

      def has_departed?
        status == 'departed'
      end

      def has_completed?
        has_arrived?
      end

      def route_departure?
        %w(origin port_of_loading).include? route_type
      end

      def route_arrival?
        %w(port_of_discharge destination).include? route_type
      end

      TYPES.each do |rt|
        define_method :"route_#{rt}?" do
          route_type == rt
        end
      end

      def display_route_type
        if route_type.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.route_types.#{route_type}"
        end
      end

      def self.route_type_options
        ::I18n.t("activerecord.attributes.#{model_name.i18n_key}.route_types").reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, (k,v)| acc << [v,k] }
      end

      def display_status
        if status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.statuses.#{status}"
        end
      end

      def self.status_options
        ::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses").reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, (k,v)| acc << [v,k] }
      end

      def self.departure_status_options
        (STATUS - %w(arrived)).reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses.#{k}"),k] }
      end

      def self.arrival_status_options
        (STATUS - %w(departed)).reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses.#{k}"),k] }
      end

    end
  end
end
