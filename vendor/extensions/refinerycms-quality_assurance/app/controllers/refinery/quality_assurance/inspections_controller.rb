module Refinery
  module QualityAssurance
    class InspectionsController < QualityAssuranceController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INSPECTIONS_URL

      allow_page_roles ROLE_EXTERNAL, only: [:index, :calendar, :download, :show]
      allow_page_roles ROLE_INTERNAL, only: [:index, :calendar, :download, :show]
      allow_page_roles ROLE_INTERNAL_MANAGER, only: [:index, :calendar, :download, :show, :update]

      before_action :find_all_inspections,  only: [:index, :calendar, :show]
      before_action :find_inspection,       except: [:index, :calendar, :new, :create, :download]

      helper_method :filter_params, :calendar_params, :inspection_defects

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            @inspections = @inspections.includes(inspection_defects: :defect, inspection_photo: :image)
            render json: @inspections.dt_response(params) if server_side?
          }
        end
      end

      def download
        @inspection_ids = []

        if params[:resource_id]
          @resource = Refinery::Resource.find(params[:resource_id])
        else
          @inspection_ids = inspections_scope.where(filter_params).where(id: params[:id]).pluck(:id)

          if @inspection_ids.length <= 100
            resources = ::Refinery::Resource.create_resources_with_access({ file: 'blank' }, {
                'User' => { user_id: current_refinery_user.id }
            })
            @resource = resources[0]

            Delayed::Job.enqueue(::ZipInspectionsJob.new(@resource.id, @inspection_ids))
          end
        end

        respond_to do |format|
          format.js
        end
      end

      def calendar
        @page = Refinery::Page.find_by(link_url: PAGE_INSPECTIONS_CALENDAR) || @page

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
          find_all_inspections
          @similar_inspections = @inspections.similar_to(@inspection).recent(10)
          present(@page)
          render :show
        end
      end

      def confirm
        if @inspection.update_attributes(inspection_params)
          redirect_to refinery.quality_assurance_inspection_path(@inspection), status: :see_other
        else
          find_all_inspections
          @similar_inspections = @inspections.similar_to(@inspection).recent(10)
          present(@page)
          render :show
        end
      end

    protected

      # def inspections_scope
      #   @inspections_scope ||= Inspection.for_selected_company(selected_company).for_user_roles(current_refinery_user, @auth_role_titles)
      #   @inspections_scope_test ||= Inspection.for_selected_company(selected_company).for_user_roles_test(current_refinery_user, @auth_role_titles)
      #
      #   if @inspections_scope.map(&:id) != @inspections_scope_test.map(&:id)
      #     ErrorMailer.webhook_notification_email('+for_user_roles+ mismatch', params.to_unsafe_h).deliver_later
      #   end
      #
      #   @inspections_scope
      # end

      def find_all_inspections
        @inspections = inspections_scope.where(filter_params)
      end

      def find_inspection
        @inspection = inspections_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id]).to_h
      end

      def calendar_params
        params.permit(:start, :end).to_h
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
