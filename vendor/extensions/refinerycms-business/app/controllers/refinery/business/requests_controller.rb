module Refinery
  module Business
    class RequestsController < BusinessController
      include Refinery::PageRoles::AuthController

      set_page PAGE_REQUESTS_URL

      allow_page_roles ROLE_INTERNAL
      allow_page_roles ROLE_EXTERNAL

      before_action :find_requests
      before_action :find_request, except: [:index, :new, :create]

      helper_method :calendar_params

      def index
        @requests = @requests.from_params(params)

        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @requests.dt_response(params) if server_side?
          }
        end
      end

      def new
        @request_form = RequestForm.new_in_model(Request.new, new_request_params)
        present(@page)
      end

      def create
        @request_form = RequestForm.new_in_model(Request.new, params[:request], current_refinery_user)
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

      def add_document
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@request)
      end

      def create_document
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@request, params[:document], current_refinery_user)
        if @document_creator.save
          flash[:notice] = 'Successfully added Document(s)'
        else
          flash[:alert] = 'Failed to add Document(s)'
        end
        redirect_to refinery.business_request_path(@request)
      end

      def destroy_document
        if destroy_attachment_and_document
          flash[:notice] = 'Successfully removed Document'
        else
          flash[:alert] = 'Failed to remove Document'
        end
        redirect_to refinery.business_request_path(@request)
      end

      protected

      def find_requests
        @requests = requests_scope.where(filter_params)
      end

      def find_request
        @request = requests_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def new_request_params
        case params[:plan]
        when 'Small' then { subject: 'Monthly Plan: Small', description: 'I am interested in signing up for the Small QA/QC monthly plan, minimum 5 Mandays per month.' }
        when 'Medium' then { subject: 'Monthly Plan: Medium', description: 'I am interested in signing up for the Medium QA/QC monthly plan, minimum 10 Mandays per month.' }
        when 'Large' then { subject: 'Monthly Plan: Large', description: 'I am interested in signing up for the Large QA/QC monthly plan, minimum 20 Mandays per month.' }
        when 'X-Large' then { subject: 'Monthly Plan: X-Large', description: 'I am interested in signing up for the X-Large QA/QC monthly plan, minimum 30 Mandays per month.' }
        else nil
        end
      end

      def update_request_params
        params.require(:request).permit()
      end

      def filter_params
        params.permit([:company_id, :project_id, :request_type, :status]).to_h
      end

      def destroy_attachment_and_document
        document = @request.documents.find params[:document_id]
        document.resource&.destroy
        document.destroy
      end
      
    end
  end
end
