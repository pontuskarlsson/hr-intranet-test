module Refinery
  module Shipping
    class ShipmentsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_SHIPMENTS_URL
      allow_page_roles ROLE_INTERNAL
      allow_page_roles ROLE_EXTERNAL
      allow_page_roles ROLE_EXTERNAL_FF

      before_filter :find_shipments,      only: [:index]
      before_filter :find_shipment,       except: [:index, :create]

      def index
        @shipment = Shipment.new(
            from_contact_label: current_authentication_devise_user.contact.try(:name),
            from_contact_id: current_authentication_devise_user.contact.try(:id)
        )
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @shipment = current_authentication_devise_user.created_shipments.build(shipment_params)
        if @shipment.save
          flash[:notice] = 'Shipment successfully added.'
          redirect_to refinery.shipping_shipment_path(@shipment)
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
        @shipment_address_updater = Refinery::Shipping::ShipmentAddressUpdater.new(shipment: @shipment)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def update
        @shipment_address_updater = Refinery::Shipping::ShipmentAddressUpdater.new({ shipment: @shipment }.reverse_merge(params[:shipment_address_updater] || {}))
        if @shipment_address_updater.save
          flash[:notice] = 'Shipment successfully updated.'
          redirect_to refinery.shipping_shipment_path(@shipment)
        else
          present(@page)
          render action: :edit
        end
      end

      def destroy
        if @shipment.destroy
          flash[:notice] = 'Successfully removed Shipment'
          redirect_to refinery.shipping_shipments_path
        else
          flash[:alert] = 'Could not remove Shipment!'
          redirect_to refinery.shipping_shipment_path(@shipment)
        end
      end

      def manual_ship
        @manual_shipper = Refinery::Shipping::ManualShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
        if @manual_shipper.save
          flash[:notice] = 'Shipment successfully Shipped.'
          redirect_to refinery.shipping_shipment_path(@shipment)
        else
          present(@page)
          render action: :show
        end
      end

      def easypost_ship
        @easypost_shipper = Refinery::Shipping::EasypostShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
        if @easypost_shipper.save
          flash[:notice] = 'Shipment successfully Updated.'
          redirect_to refinery.shipping_shipment_path(@shipment)
        else
          present(@page)
          render action: :show
        end
      end

      protected

      def shipments_scope
        @shipments ||=
            if page_role? Refinery::Shipping::ROLE_INTERNAL
              Refinery::Shipping::Shipment.where(nil)

            elsif page_role? Refinery::Shipping::ROLE_EXTERNAL_FF
              Refinery::Shipping::Shipment.where(forwarder_company_id: current_authentication_devise_user.company_ids)

            else
              Refinery::Shipping::Shipment.where('1=0')
            end
      end

      def find_shipments
        @shipments = shipments_scope.where(filter_params)
      end

      def find_shipment
        @shipment = Shipment.find(params[:id])
      end

      def shipment_params
        params.require(:shipment).permit(:from_contact_label, :to_contact_label, :courier_company_label, :assigned_to_label, :from_contact_id, :to_contact_id, :bill_to, :bill_to_account_id, :position, :created_by_id, :assigned_to_id)
      end

      def filter_params
        params.permit([:shipper_company_id, :receiver_company_id, :consignee_company_id, :supplier_company_id, :project_id, :status, :courier_company_label])
      end

    end
  end
end
