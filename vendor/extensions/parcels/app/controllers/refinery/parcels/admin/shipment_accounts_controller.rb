module Refinery
  module Parcels
    module Admin
      class ShipmentAccountsController < ::Refinery::AdminController

        crudify :'refinery/parcels/shipment_account',
                :title_attribute => 'description',
                order: 'created_at DESC'

        def shipment_account_params
          params.require(:shipment_account).permit(:contact_id, :courier, :description, :account_no, :contact_name, :position)
        end
      end
    end
  end
end
