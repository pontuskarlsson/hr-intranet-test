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

      helper_method :default_package_fields, :default_cost_fields, :costs_form, :items_form, :packages_form, :routes_form

      def index
        @shipment = Shipment.new(
            # from_contact_label: current_authentication_devise_user.contact.try(:name),
            # from_contact_id: current_authentication_devise_user.contact.try(:id)
        )

        @shipments = @shipments.from_params(params)

        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
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
        if shipment_form_saved?
          flash[:notice] = 'Shipment successfully updated.'
          redirect_to refinery.shipping_shipment_path(@shipment)
        else
          present(@page)
          render action: :show
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

      # def easypost_ship
      #   @easypost_shipper = Refinery::Shipping::EasypostShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
      #   if @easypost_shipper.save
      #     flash[:notice] = 'Shipment successfully Updated.'
      #     redirect_to refinery.shipping_shipment_path(@shipment)
      #   else
      #     present(@page)
      #     render action: :show
      #   end
      # end

      def add_document
        @document_creator = ::Refinery::Shipping::DocumentCreator.new_in_model(@shipment)
      end

      def create_document
        @document_creator = ::Refinery::Shipping::DocumentCreator.new_in_model(@shipment, params[:document], current_authentication_devise_user)
        if @document_creator.save
          flash[:notice] = 'Successfully added Document(s)'
        else
          flash[:alert] = 'Failed to add Document(s)'
        end
        redirect_to refinery.shipping_shipment_path(@shipment)
      end

      def destroy_document
        if destroy_attachment_and_document
          flash[:notice] = 'Successfully removed Document'
        else
          flash[:alert] = 'Failed to remove Document'
        end
        redirect_to refinery.shipping_shipment_path(@shipment)
      end

      def locations
        respond_to do |format|
          format.json { render json: Location.with_query(search_terms).limit(10), methods: [:label, :value] }
        end
      end

      protected

      def shipments_scope
        @shipments ||= Shipment.for_user_roles(current_authentication_devise_user, @auth_role_titles)
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
            :no_of_parcels, :weight_unit, :gross_weight_manual_amount, :net_weight_manual_amount, :chargeable_weight_manual_amount, :volume_unit, :volume_manual_amount, :cargo_ready_date
        )
      end

      def filter_params
        params.permit([:shipper_company_id, :receiver_company_id, :consignee_company_id, :supplier_company_id, :project_id, :status, :courier_company_label])
      end

      def default_package_fields
        {
            package_type: 'Carton',
            length_unit: @shipment.try(:length_unit).presence || 'cm',
            weight_unit: @shipment.try(:weight_unit).presence || 'kg'
        }
      end

      def default_cost_fields
        {
            #currency_code: nil
        }
      end

      def destroy_attachment_and_document
        document = @shipment.documents.find params[:document_id]
        document.resource.destroy
        document.destroy
      end

      def shipment_form_saved?
        if params[:update_packages]
          packages_form.save

        elsif params[:send_request]
          @shipment.update_status('requested')

        elsif params[:costs_form]
          costs_form.save

        elsif params[:items_form]
          items_form.save

        elsif params[:routes_form]
          routes_form.save

        else
          @shipment.update_attributes(shipment_params)
        end
      end

      def costs_form
        @costs_form ||= Refinery::Shipping::CostsForm.new_in_model(@shipment, params[:costs_form], current_authentication_devise_user)
      end

      def items_form
        @items_form ||= Refinery::Shipping::ItemsForm.new_in_model(@shipment, params[:items_form], current_authentication_devise_user)
      end

      def routes_form
        @route_form ||= Refinery::Shipping::RoutesForm.new_in_model(@shipment, params[:routes_form], current_authentication_devise_user)
      end

      def packages_form
        @packages_form ||= Refinery::Shipping::PackagesForm.new_in_model(@shipment, params[:shipment], current_authentication_devise_user)
      end

      def search_terms
        if params[:term]
          params[:term].to_s.split(' ').map { |t| "^#{t}" }.join(' ')
        else
          ''
        end
      end

    end
  end
end
