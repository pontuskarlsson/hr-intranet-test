module Refinery
  module QualityAssurance
    class DefectsController < QualityAssuranceController
      include Refinery::PageRoles::AuthController

      set_page PAGE_DEFECTS_URL

      allow_page_roles ROLE_EXTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL, only: [:index, :show, :edit, :update]

      before_action :find_all_defects,  only: [:index]
      before_action :find_defect,       except: [:index]

      helper_method :filter_params, :similar_to

      # Form instance accessors
      helper_method :possible_causes_form

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @defects.dt_response(params) if server_side?
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
        if defect_form_saved?
          flash[:notice] = 'Defect successfully updated.'
          redirect_to refinery.quality_assurance_defect_path(@defect)
        else
          present(@page)
          render action: :show
        end
      end

      protected

      def find_all_defects
        @defects = defects_scope.where(filter_params)
      end

      def find_defect
        @defect = defects_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id]).to_h
      end

      def defect_params
        params.require(:defect).permit(:category_code, :category_name, :defect_code, :defect_name)
      end

      def defect_form_saved?
        if params[:update_causes]
          possible_causes_form.save

        else
          @defect.update_attributes(defect_params)
        end
      end

      def possible_causes_form
        @possible_cause_form ||= PossibleCausesForm.new_in_model(@defect, params[:defect], current_refinery_user)
      end

      def similar_to(defect)
        @similar_to ||= defects_scope.similar_to(defect)
      end

    end
  end
end
