module Refinery
  module CustomLists
    class CustomListsController < ::ApplicationController

      before_action :find_all_custom_lists
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @custom_list in the line below:
        present(@page)
      end

      def show
        @custom_list = CustomList.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @custom_list in the line below:
        present(@page)
      end

    protected

      def find_all_custom_lists
        @custom_lists = CustomList.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/custom_lists', current_refinery_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
