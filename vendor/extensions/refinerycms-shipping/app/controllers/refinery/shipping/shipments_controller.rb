module Refinery
  module Shipping
    class ShipmentsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_SHIPMENTS_URL
      allow_page_roles ROLE_INTERNAL
      allow_page_roles ROLE_EXTERNAL,     only: [:index, :show, :edit, :update]
      allow_page_roles ROLE_EXTERNAL_FF,  only: [:index, :show, :edit, :update]

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

      def new
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

        if (params[:shipment_address_updater] ? @shipment_address_updater.save : @shipment.update_attributes(shipment_params))
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
        @shipment = shipments_scope.find(params[:id])
      end

      def shipment_params
        params.require(:shipment).permit(
            :supplier_company_label, :shipper_company_label, :receiver_company_label, :consignee_company_label, :courier_company_label, :forwarder_company_label,
            :load_port, :consignee_reference, :forwarder_booking_number, :mode, :status, :etd_date, :eta_date, :tracking_number, :shipment_terms, :shipment_terms_details,
            :rate_currency, :duty_amount, :terminal_fee_amount, :domestic_transportation_cost_amount, :forwarding_fee_amount, :freight_cost_amount,
            :no_of_parcels, :weight_unit, :gross_weight_manual_amount, :net_weight_manual_amount, :chargeable_weight_manual_amount, :volume_unit, :volume_manual_amount
        )
      end

      def filter_params
        params.permit([:shipper_company_id, :receiver_company_id, :consignee_company_id, :supplier_company_id, :project_id, :status, :courier_company_label])
      end

    end
  end
end
