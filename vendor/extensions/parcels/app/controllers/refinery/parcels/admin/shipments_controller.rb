module Refinery
  module Parcels
    module Admin
      class ShipmentsController < ::Refinery::AdminController

        crudify :'refinery/parcels/shipment',
                :title_attribute => 'to_contact_name',
                :xhr_paging => true,
                order: 'created_at DESC'

      end
    end
  end
end
