module Refinery
  module CustomLists
    class ListRowsController < ::ApplicationController
      before_action :find_custom_list
      before_action :find_list_row,   only: [:edit, :update, :destroy]
      before_action :find_page

      def create
        @list_row_creator = ListRowCreator.new({ custom_list: @custom_list }.reverse_merge(params[:list_row_creator]))
        @list_row_creator.save
        redirect_to_page
      end

      def edit
        @list_row_updater = ::Refinery::CustomLists::ListRowUpdater.new({ list_row: @list_row })
      end

      def update
        @list_row_updater = ListRowUpdater.new({ list_row: @list_row }.reverse_merge(params[:list_row_updater]))
        @list_row_updater.save
        redirect_to_page
      end

      def destroy
        redirect_to_page
      end

    protected
      def find_custom_list
        @custom_list = CustomList.find(params[:custom_list_id])
      end

      def find_list_row
        @list_row = @custom_list.list_rows.find(params[:id])
      end

      def find_page
        @page = ::Refinery::Page.find(params[:originating_page_id])
        error_404 unless @page.user_authorized?(current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def redirect_to_page
        redirect_to "#{refinery.root_path}#{@page.url[:path].join('/')}", status: :see_other
      end

    end
  end
end
