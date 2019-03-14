module Refinery
  module Parcels
    class ShipmentsController < ::ApplicationController
      before_filter :authenticate_authentication_devise_user!
      before_filter :find_all_shipments,  only: [:index]
      before_filter :find_shipment,       except: [:index, :create]
      before_filter :find_page

      def index
        @shipment = Shipment.new(from_contact_name: current_authentication_devise_user.contact.try(:name), from_contact_id: current_authentication_devise_user.contact.try(:id))
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @shipment = current_authentication_devise_user.created_shipments.build(shipment_params)
        if @shipment.save
          flash[:notice] = 'Shipment successfully added.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          find_all_shipments
          present(@page)
          render action: :index
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def edit
        @shipment_address_updater = Refinery::Parcels::ShipmentAddressUpdater.new(shipment: @shipment)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        @shipment_address_updater = Refinery::Parcels::ShipmentAddressUpdater.new({ shipment: @shipment }.reverse_merge(params[:shipment_address_updater] || {}))
        if @shipment_address_updater.save
          flash[:notice] = 'Shipment successfully updated.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          present(@page)
          render action: :edit
        end
      end

      def destroy
        if @shipment.destroy
          flash[:notice] = 'Successfully removed Shipment'
          redirect_to refinery.parcels_shipments_path
        else
          flash[:alert] = 'Could not remove Shipment!'
          redirect_to refinery.parcels_shipment_path(@shipment)
        end
      end

      def manual_ship
        @manual_shipper = Refinery::Parcels::ManualShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
        if @manual_shipper.save
          flash[:notice] = 'Shipment successfully Shipped.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          present(@page)
          render action: :show
        end
      end

      def easypost_ship
        @easypost_shipper = Refinery::Parcels::EasypostShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
        if @easypost_shipper.save
          flash[:notice] = 'Shipment successfully Updated.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        else
          present(@page)
          render action: :show
        end
      end

      protected

      def find_all_shipments
        @shipments = Shipment.includes(:from_contact, :to_contact, :assigned_to).order('updated_at DESC, id DESC')
        unless params[:view_all] == '1'
          @shipments = @shipments.where('created_at > ?', DateTime.now - 3.months)
        end
      end

      def find_shipment
        @shipment = Shipment.find(params[:id])
      end

      def find_page
        @page = ::Refinery::Page.where(link_url: '/parcels/shipments').first
      end

      def shipment_params
        params.require(:shipment).permit(:from_contact_name, :to_contact_name, :courier, :assign_to, :from_contact_id, :to_contact_id, :bill_to, :bill_to_account_id, :position, :created_by_id, :assigned_to_id)
      end

    end
  end
end
