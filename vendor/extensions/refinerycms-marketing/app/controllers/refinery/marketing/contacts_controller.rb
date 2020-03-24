module Refinery
  module Marketing
    class ContactsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_CONTACTS_URL
      allow_page_roles ::Refinery::Business::ROLE_INTERNAL, only: [:index, :show]
      allow_page_roles ROLE_CRM_MANAGER

      before_action :find_contacts, only: [:index]
      before_action :find_contact,  except: [:index, :new, :create]

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @contacts.dt_response(params) if server_side?
          }
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)
      end

      protected

      def contacts_scope
        @contacts ||= Contact.for_user_roles current_refinery_user
      end

      def find_contacts
        contacts_scope
      end

      def find_contact
        @contact = contacts_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
