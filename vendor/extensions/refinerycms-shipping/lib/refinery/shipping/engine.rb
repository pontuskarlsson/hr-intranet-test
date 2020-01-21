module Refinery
  module Shipping
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Shipping

      engine_name :refinery_shipping

      initializer 'resource-authorization-hooks-for-shipping-engine' do |app|
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Shipping::ROLE_INTERNAL

        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Shipping::ROLE_EXTERNAL do |user, conditions|
          shipment = Shipment.find conditions[:shipment_id]
          user.company_ids.include? shipment.consignee_company_id
        end

        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Shipping::ROLE_EXTERNAL_FF do |user, conditions|
          shipment = Shipment.find conditions[:shipment_id]
          user.company_ids.include? shipment.forwarder_company_id
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "shipping"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.shipping_admin_shipments_path }
          plugin.pathname = root

          # Menu match controls access to the admin backend routes.
          plugin.menu_match = %r{refinery/shipping(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Shipping)
      end
    end
  end
end
