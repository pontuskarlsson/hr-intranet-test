module Refinery
  module Marketing
    module Admin
      class ContactsController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:synchronise]

        crudify :'refinery/marketing/contact',
                :title_attribute => 'name',
                order: 'name ASC'

        def synchronise
          # @synchroniser = Refinery::Marketing::BaseSynchroniser.new
          # if @synchroniser.synchronise
          #   flash[:info] = 'Succesfully synchronised contacts'
          # else
          #   flash[:warning] = "Failed to import Contacts:\n#{ @synchroniser.error.message }"
          # end

          redirect_to refinery.marketing_admin_contacts_path
        end

        def contact_params
          params.require(:contact).permit(
              :base_id, :code, :name, :first_name, :last_name, :address,
              :city, :skype, :zip, :state, :country, :title, :private,
              :contact_id, :is_organisation, :mobile, :fax,
              :website, :phone, :description, :linked_in, :facebook,
              :industry, :twitter, :email, :organisation_name,
              :tags_joined_by_comma, :position, :user_id, :insightly_id,
              :courier_company, :courier_account_no, :image_url, :xero_hr_id, :xero_hrt_id
          )
        end

      end
    end
  end
end
