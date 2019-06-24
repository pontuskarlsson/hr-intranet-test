module Refinery
  module Shipping
    module Admin
      class ShipmentsController < ::Refinery::AdminController

        crudify :'refinery/shipping/shipment',
                :title_attribute => 'to_contact_name',
                order: 'created_at DESC'

        def shipment_params
          params.require(:shipment).permit(:from_contact_name, :to_contact_name, :courier, :assign_to, :from_contact_id, :to_contact_id, :bill_to, :bill_to_account_id, :position, :created_by_id, :assigned_to_id)
        end

      end
    end
  end
end
