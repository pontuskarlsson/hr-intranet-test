module Refinery
  module Parcels
    class ShipmentParcelsController < ::ApplicationController
      before_filter :authenticate_refinery_user!
      before_filter :find_shipment
      before_filter :find_shipment_parcel, only: [:show, :update]
      before_filter :find_page

      def index
        @shipment = Shipment.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @shipment_parcel = @shipment.shipment_parcels.build(params[:shipment_parcel])
        if @shipment_parcel.save
          flash[:notice] = 'Parcel successfully added to Shipment.'
        else
          flash[:alert] = 'Parcel could not be added.'
        end
        redirect_to refinery.parcels_shipment_path(@shipment)
      end

      def show
        @shipment = Shipment.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        if @parcel.update_attributes(params[:parcel])
          flash[:notice] = 'Parcel successfully updated.'
          redirect_to refinery.parcels_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

      protected

      def find_shipment
        @shipment = Shipment.find(params[:shipment_id])
      end

      def find_shipment_parcel
        @shipment_parcel = @shipment.shipment_parcels.find(params[:id])
      end

      def find_page
        @page = ::Refinery::Page.where(link_url: '/parcels/shipments').first
      end

    end
  end
end
