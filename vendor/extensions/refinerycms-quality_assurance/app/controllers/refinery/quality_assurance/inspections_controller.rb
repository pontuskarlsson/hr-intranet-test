module Refinery
  module QualityAssurance
    class InspectionsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INSPECTIONS_URL
      allow_page_roles ROLE_EXTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL

      before_action :find_all_inspections,  only: [:index, :show]
      before_action :find_inspection,       except: [:index, :new, :create]

      helper_method :filter_params

      def index
        @inspections = @inspections.where(filter_params)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

      def show
        @similar_inspections = @inspections.similar_to(@inspection).recent(10)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

    protected

      def inspections_scope
        @inspections ||=
            if page_role? ROLE_INTERNAL
              Inspection.where(nil)
            elsif page_role? ROLE_INSPECTOR
              Inspection.inspected_by(current_authentication_devise_user)
            elsif page_role? ROLE_EXTERNAL
              Inspection.for_companies(current_authentication_devise_user.companies)
            else
              Inspection.where('1=0')
            end
      end

      def find_all_inspections
        @inspections = inspections_scope.order(inspection_date: :desc)
      end

      def find_inspection
        @inspection = inspections_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id])
      end

    end
  end
end
