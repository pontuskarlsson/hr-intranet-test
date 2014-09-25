module Refinery
  module Parcels
    class ParcelsController < ::ApplicationController
      skip_before_filter :verify_authenticity_token, only: [:sign]

      before_filter :find_all_parcels
      before_filter :find_page

      def index
        @parcel = Parcel.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @parcel = Parcel.new(params[:parcel])
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

      def sign
        @parcel = current_refinery_user.parcels.unsigned.find(params[:id])
        @parcel.receiver_signed = true
        if @parcel.save
          flash[:info] = 'Parcel successfully signed for.'
          redirect_to refinery.parcels_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

    protected

      def find_all_parcels
        @parcels = Parcel.order('parcel_date DESC')

        @my_unsigned_parcels = current_refinery_user.parcels.unsigned.order('parcel_date ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/parcels").first
      end

    end
  end
end
