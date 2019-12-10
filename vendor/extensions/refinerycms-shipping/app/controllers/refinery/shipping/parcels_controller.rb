module Refinery
  module Shipping
    class ParcelsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_PARCELS_URL
      allow_page_roles ROLE_INTERNAL

      before_action :find_all_parcels
      before_action :authorize_for_parcel, only: [:update, :sign, :pass_on]

      def index
        @parcel = Parcel.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @parcel in the line below:
        present(@page)
      end

      def create
        @parcel = current_authentication_devise_user.received_parcels.build(parcel_params)
        if @parcel.save
          flash[:notice] = 'Parcel successfully added.'
          redirect_to refinery.shipping_parcels_path
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
        if @parcel.update_attributes(parcel_params)
          flash[:notice] = 'Parcel successfully updated.'
          redirect_to refinery.shipping_parcels_path
        else
          present(@page)
          render action: :index
        end
      end

      def sign
      end

      def pass_on
      end

    protected

      def find_all_parcels
        @parcels = Parcel.order('parcel_date DESC, id DESC')
        unless params[:view_all] == '1'
          @parcels = @parcels.where('created_at > ?', DateTime.now - 3.months)
        end

        @my_unsigned_parcels = current_authentication_devise_user.assigned_parcels.unsigned.order('parcel_date ASC')
      end

      def authorize_for_parcel
        @parcel = current_authentication_devise_user.assigned_parcels.find_by_id(params[:id])
        @parcel = current_authentication_devise_user.received_parcels.find_by_id(params[:id]) if @parcel.nil?
        if @parcel.nil?
          flash[:alert] = 'You are not authorized to update that parcel'
          redirect_to refinery.shipping_parcels_path
        end
      end

      def parcel_params
        params.require(:parcel).permit(:parcel_date, :from, :courier, :air_waybill_no, :to, :shipping_document_id, :position, :received_by, :assigned_to, :description, :given_to, :receiver_signed, :received_by_id)
      end

    end
  end
end
