module Refinery
  module Parcels
    module Admin
      class ShipmentAccountsController < ::Refinery::AdminController

        crudify :'refinery/parcels/shipment_account',
                :title_attribute => 'description',
                :xhr_paging => true,
                order: 'created_at DESC'

      end
    end
  end
end
