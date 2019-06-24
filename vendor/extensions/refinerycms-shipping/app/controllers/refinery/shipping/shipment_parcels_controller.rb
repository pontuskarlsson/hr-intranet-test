module Refinery
  module Shipping
    class ShipmentParcelsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_SHIPMENTS_URL
      allow_page_roles ROLE_INTERNAL

      before_filter :find_shipment
      before_filter :find_shipment_parcel, only: [:show, :update, :destroy]

      def index
        @shipment = Shipment.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @shipment_parcel = @shipment.shipment_parcels.build(shipment_parcel_params)
        if @shipment_parcel.save
          flash[:notice] = 'Parcel successfully added to Shipment.'
        else
          flash[:alert] = 'Parcel could not be added.'
        end
        redirect_to refinery.shipping_shipment_path(@shipment)
      end

      def show
        @shipment = Shipment.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        if @parcel.update_attributes(shipment_parcel_params)
          flash[:notice] = 'Parcel successfully updated.'
          redirect_to refinery.shipping_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

      def destroy
        if @shipment_parcel.destroy
          flash[:notice] = 'Parcel successfully removed.'
        else
          flash[:alert] = 'Failed to remove Parcel.'
        end
        redirect_to refinery.shipping_shipment_path(@shipment)
      end

      protected

      def find_shipment
        @shipment = Shipment.find(params[:shipment_id])
      end

      def find_shipment_parcel
        @shipment_parcel = @shipment.shipment_parcels.find(params[:id])
      end

      def shipment_parcel_params
        params.require(:shipment_parcel).permit(:length, :width, :height, :weight, :predefined_package, :description, :quantity, :value, :origin_country, :contents_type)
      end

    end
  end
end
