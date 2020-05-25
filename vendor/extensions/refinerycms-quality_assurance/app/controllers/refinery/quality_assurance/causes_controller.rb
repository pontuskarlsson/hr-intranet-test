module Refinery
  module QualityAssurance
    class CausesController < QualityAssuranceController
      include Refinery::PageRoles::AuthController

      set_page PAGE_CAUSES_URL

      allow_page_roles ROLE_EXTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL, only: [:index, :show, :edit, :update]

      before_action :find_all_causes,  only: [:index]
      before_action :find_cause,       except: [:index]

      helper_method :filter_params, :similar_to

      # Form instance accessors
      helper_method :possible_causes_form

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @causes.dt_response(params) if server_side?
          }
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

      def edit
        respond_to do |format|
          format.html { render action: :show }
          format.js
        end
      end

      def update
        if cause_form_saved?
          flash[:notice] = 'Cause successfully updated.'
          redirect_to refinery.quality_assurance_cause_path(@cause)
        else
          present(@page)
          render action: :show
        end
      end

      protected

      def find_all_causes
        @causes = causes_scope.where(filter_params)
      end

      def find_cause
        @cause = causes_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([]).to_h
      end

      def cause_params
        params.require(:cause).permit(:category_code, :category_name, :cause_code, :cause_name)
      end

      def cause_form_saved?
        if params[:update_causes]
          # possible_causes_form.save

        else
          @cause.update_attributes(cause_params)
        end
      end

      def similar_to(cause)
        @similar_to ||= causes_scope.similar_to(cause)
      end

    end
  end
end
