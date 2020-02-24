module Refinery
  module Business
    class BillablesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_BILLABLES_URL
      allow_page_roles ROLE_INTERNAL_FINANCE
      allow_page_roles ROLE_INTERNAL, only: [:index, :calendar, :show]

      before_action :find_billables
      before_action :find_billable, except: [:index, :calendar, :new, :create]

      helper_method :calendar_params

      def index
        @billables = @billables.from_params(params)

        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @billables.dt_response(params) if server_side?
          }
        end
      end

      def calendar
        @billables = @billables.from_params(params).order(billable_date: :desc)

        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def new
        #@billable_form = BillableForm.new_in_model(Billable.new)
        present(@page)
      end

      def create
        # @billable_form = BillableForm.new_in_model(Billable.new, params[:billable], current_refinery_user)
        # if @billable_form.save
        #   redirect_to refinery.business_billable_path(@billable_form.billable)
        # else
        #   present(@page)
        #   render action: :new
        # end
      end

      def show
        present(@page)
      end

      def update
        if @billable.update_attributes(billable_params)
          flash[:notice] = 'Successfully updated the Billable'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.business_billable_path(@billable), status: :see_other
          end
        else
          present(@page)
          render :show
        end
      end

      protected

      def billable_scope
        @billables =
            if page_role? ROLE_INTERNAL_FINANCE
              Refinery::Business::Billable.where(nil)
            elsif page_role? ROLE_INTERNAL
              Refinery::Business::Billable.where(nil)
            else
              Refinery::Business::Billable.where('1=0')
            end
      end

      def find_billables
        @billables = billable_scope.where(filter_params)
      end

      def find_billable
        @billable = billable_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def billable_params
        params.require(:billable).permit(:article_code, :assigned_to_label, :assigned_to_id, :company_id, :company_label, :description, :project_id, :project_label, :invoice_id, :invoice_label, :section_id, :title, :status)
      end

      def filter_params
        params.permit([:company_id, :project_id, :section_id, :billable_type, :article_code, :invoice_id, :status]).to_h
      end

      def calendar_params
        params.permit(:start, :end).to_h
      end
      
    end
  end
end
