module Refinery
  module Marketing
    class ContactsController < ::ApplicationController

      before_filter :find_all_contacts, only: [:index]
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)
      end

      def show
        @contact = Contact.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)
      end

      protected

      def find_all_contacts
        @contacts = Contact.order('name ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/marketing/contacts").first
      end

    end
  end
end
