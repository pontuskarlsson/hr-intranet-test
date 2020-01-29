module Refinery
  module Business
    class RequestsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_REQUESTS_URL
      allow_page_roles ROLE_INTERNAL
      allow_page_roles ROLE_EXTERNAL

      before_action :find_requests
      before_action :find_request, except: [:index, :new, :create]

      helper_method :calendar_params

      def index
        @requests = @requests.from_params(params).order(request_date: :desc)

        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @requests.dt_response(params) if server_side?
          }
        end
      end

      def new
        @request_form = RequestForm.new_in_model(Request.new)
        present(@page)
      end

      def create
        @request_form = RequestForm.new_in_model(Request.new, params[:request], current_authentication_devise_user)
        if @request_form.save
          redirect_to refinery.business_request_path(@request_form.request)
        else
          present(@page)
          render action: :new
        end
      end

      def show
        present(@page)
      end

      def update
        if @request.update_attributes(request_params)
          flash[:notice] = 'Successfully updated the Request'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.business_request_path(@request), status: :see_other
          end
        else
          present(@page)
          render :show
        end
      end

      protected

      def requests_scope
        @requests = Refinery::Business::Request.for_user_roles(current_authentication_devise_user)
      end

      def find_requests
        @requests = requests_scope.where(filter_params)
      end

      def find_request
        @request = requests_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def update_request_params
        params.require(:request).permit()
      end

      def filter_params
        params.permit([:company_id, :project_id, :request_type, :status]).to_h
      end
      
    end
  end
end
