module Refinery
  module Parcels
    module Admin
      class ParcelsController < ::Refinery::AdminController

        crudify :'refinery/parcels/parcel',
                :title_attribute => 'from_name',
                :xhr_paging => true,
                order: 'parcel_date DESC'

      end
    end
  end
end
