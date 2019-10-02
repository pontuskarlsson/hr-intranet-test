module Refinery
  module QualityAssurance
    class InspectionsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INSPECTIONS_URL
      allow_page_roles ROLE_EXTERNAL, only: [:index, :calendar, :defects, :show]
      allow_page_roles ROLE_INTERNAL, only: [:index, :calendar, :defects, :show]
      allow_page_roles ROLE_INTERNAL_MANAGER, only: [:index, :calendar, :defects, :show, :update]

      before_action :find_all_inspections,  only: [:index, :calendar, :defects, :show]
      before_action :find_inspection,       except: [:index, :calendar, :defects, :new, :create]

      helper_method :filter_params, :calendar_params, :inspection_defects

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def calendar
        @page = Refinery::Page.find_by(link_url: PAGE_INSPECTIONS_CALENDAR) || @page

        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def defects
        @page = Refinery::Page.find_by(link_url: PAGE_INSPECTIONS_DEFECTS) || @page

        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def show
        @similar_inspections = @inspections.similar_to(@inspection).recent(10)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

      def update
        if @inspection.update_attributes(inspection_params)
          if notify_users.any?
            ActivityNotification::Notification.notify_all notify_users.to_a, @inspection, notify_later: true
          end
          redirect_to refinery.quality_assurance_inspection_path(@inspection), status: :see_other
        else
          @similar_inspections = @inspections.similar_to(@inspection).recent(10)
          present(@page)
          render :show
        end
      end

      def confirm
        if @inspection.update_attributes(inspection_params)
          redirect_to refinery.quality_assurance_inspection_path(@inspection), status: :see_other
        else
          @similar_inspections = @inspections.similar_to(@inspection).recent(10)
          present(@page)
          render :show
        end
      end

    protected

      def inspections_scope
        @inspections ||=
            if page_role?(ROLE_INTERNAL) or page_role?(ROLE_INTERNAL_MANAGER)
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
        @inspections = inspections_scope.where(filter_params).order(inspection_date: :desc)
      end

      def find_inspection
        @inspection = inspections_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id])
      end

      def calendar_params
        params.permit(:start, :end)
      end

      def inspection_params
        params.require(:inspection).permit(:status)
      end

      def notify_users
        @notify_users ||=
            if @inspection.company.present?
              @inspection.company.users.where(id: params[:notify_users])
            else
              []
            end
      end

      def inspection_defects
        @inspection_defects ||= @inspections.includes(inspection_defects: :defect).each_with_object([]) { |inspection, acc|
          inspection.inspection_defects.each do |inspection_defect|
            acc << [inspection, inspection_defect]
          end
        }
      end

    end
  end
end
