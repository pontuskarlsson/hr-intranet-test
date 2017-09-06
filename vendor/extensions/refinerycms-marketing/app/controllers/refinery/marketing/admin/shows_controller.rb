module Refinery
  module Marketing
    module Admin
      class ShowsController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:sync]

        crudify :'refinery/marketing/show',
                :title_attribute => 'name',
                :xhr_paging => true,
                order: 'name ASC'

        prepend_before_filter :find_show, only: [:sync, :update, :destroy, :edit, :show]

        def sync
          redirect_to redirect_url
        end

      end
    end
  end
end
