module Refinery
  module Shipping
    module Admin
      class ShipmentsController < ::Refinery::AdminController

        crudify :'refinery/shipping/shipment',
                :title_attribute => 'to_contact_label',
                order: 'created_at DESC'

        def shipment_params
          params.require(:shipment).permit(
              :from_contact_label, :to_contact_label, :courier_company_label, :assigned_to_label, :from_contact_id, :to_contact_id,
              :bill_to, :bill_to_account_id, :position, :created_by_id, :assigned_to_id,
              :rate_currency, :duty_amount, :terminal_fee_amount, :domestic_transportation_cost_amount,
              :forwarding_fee_amount, :freight_cost_amount, :gross_weight_amount, :gross_weight_manual_amount,
              :net_weight_amount, :net_weight_manual_amount, :chargeable_weight_amount, :chargeable_weight_manual_amount,
              :weight_unit, :volume_amount, :volume_manual_amount, :volume_unit, :archived_at
          )
        end

      end
    end
  end
end
