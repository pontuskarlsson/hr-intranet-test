module Refinery
  module Marketing
    module Admin
      class ContactsController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:synchronise]

        crudify :'refinery/marketing/contact',
                :title_attribute => 'name',
                :xhr_paging => true,
                order: 'name ASC'

        def synchronise
          @synchroniser = Refinery::Marketing::BaseSynchroniser.new
          if @synchroniser.synchronise
            flash[:info] = 'Succesfully synchronised contacts'
          else
            flash[:warning] = "Failed to import Contacts:\n#{ @synchroniser.error.message }"
          end

          redirect_to refinery.marketing_admin_contacts_path
        end

      end
    end
  end
end
