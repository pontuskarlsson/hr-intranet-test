module Refinery
  module Parcels
    class ShipmentsController < ::ApplicationController
      before_filter :authenticate_refinery_user!
      before_filter :find_all_shipments
      before_filter :find_page

      def index
        @shipment = Shipment.new(from_contact_id: current_refinery_user.contact.try(:id))
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @shipment = current_refinery_user.created_shipments.build(params[:shipment])
        if @shipment.save
          flash[:notice] = 'Shipment successfully added.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          present(@page)
          render action: :index
        end
      end

      def show
        @shipment = Shipment.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def edit
        @shipment = Shipment.find(params[:id])
        @shipment_address_updater = Refinery::Parcels::ShipmentAddressUpdater.new(shipment: @shipment)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        @shipment = Shipment.find(params[:id])
        @shipment_address_updater = Refinery::Parcels::ShipmentAddressUpdater.new({ shipment: @shipment }.reverse_merge(params[:shipment_address_updater] || {}))
        if @shipment_address_updater.save
          flash[:notice] = 'Shipment successfully updated.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          present(@page)
          render action: :index
        end
      end

      protected

      def find_all_shipments
        @shipments = Shipment.includes(:from_contact, :to_contact, :assigned_to).order('updated_at DESC, id DESC')
      end

      def find_page
        @page = ::Refinery::Page.where(link_url: '/parcels/shipments').first
      end

    end
  end
end
