module Refinery
  module Marketing
    module Admin
      class ShowsController < ::Refinery::AdminController
        skip_before_action :verify_authenticity_token, only: [:sync]

        crudify :'refinery/marketing/show',
                :title_attribute => 'name',
                order: 'name ASC'

        prepend_before_action :find_show, only: [:sync, :update, :destroy, :edit, :show]

        def sync
          redirect_to redirect_url
        end

        def show_params
          params.require(:show).permit(
              :name, :website, :logo_id, :description, :position, :msg_json_struct
          )
        end

      end
    end
  end
end
