module Refinery
  module Marketing
    module Admin
      class LandingPagesController < ::Refinery::AdminController

        crudify :'refinery/marketing/landing_page',
                :title_attribute => 'title',
                order: 'title ASC',
                sortable: false

        def landing_page_params
          params.require(:landing_page).permit(
              :title, :slug, :campaign_id, :page_id, :page_slug
          )
        end

      end
    end
  end
end
