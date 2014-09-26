module Refinery
  module Parcels
    class ParcelsController < ::ApplicationController
      before_filter :find_all_parcels
      before_filter :find_page

      def index
        @parcel = Parcel.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @parcel = current_refinery_user.received_parcels.build(params[:parcel])
        if @parcel.save
          flash[:info] = 'Parcel successfully added.'
          redirect_to refinery.parcels_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

      def show
        @parcel = Parcel.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        @parcel = current_refinery_user.assigned_parcels.find(params[:id])
        if @parcel.update_attributes(params[:parcel])
          flash[:info] = 'Parcel successfully updated.'
          redirect_to refinery.parcels_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

      def sign
        @parcel = current_refinery_user.assigned_parcels.find(params[:id])
      end

      def pass_on
        @parcel = current_refinery_user.assigned_parcels.find(params[:id])
      end

    protected

      def find_all_parcels
        @parcels = Parcel.order('parcel_date DESC')

        @my_unsigned_parcels = current_refinery_user.assigned_parcels.unsigned.order('parcel_date ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/parcels").first
      end

    end
  end
end
