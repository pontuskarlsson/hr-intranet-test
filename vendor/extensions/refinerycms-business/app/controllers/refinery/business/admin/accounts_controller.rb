module Refinery
  module Business
    module Admin
      class AccountsController < ::Refinery::AdminController

        crudify :'refinery/business/account',
                :title_attribute => 'organisation',
                order: 'organisation ASC'

        def account_params
          params.require(:account).permit(
              :organisation, :key_content, :consumer_key, :consumer_secret, :encryption_key, :bank_details
          )
        end

      end
    end
  end
end
