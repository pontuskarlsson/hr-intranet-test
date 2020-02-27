module Refinery
  module Marketing
    module Admin
      class CampaignsController < ::Refinery::AdminController

        crudify :'refinery/marketing/campaign',
                :title_attribute => 'title',
                order: 'title ASC',
                sortable: false

        def campaign_params
          params.require(:campaign).permit(
              :title
          )
        end

      end
    end
  end
end
