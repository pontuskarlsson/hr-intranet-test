module Refinery
  module Shipping
    module Admin
      class ParcelsController < ::Refinery::AdminController

        crudify :'refinery/shipping/parcel',
                :title_attribute => 'from_name',
                order: 'parcel_date DESC'

        def parcel_params
          params.require(:parcel).permit(:parcel_date, :from, :courier, :air_waybill_no, :to, :shipping_document_id, :position, :received_by, :assigned_to, :description, :given_to, :receiver_signed, :received_by_id)
        end

      end
    end
  end
end
