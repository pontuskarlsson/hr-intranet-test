module Refinery
  module QualityAssurance
    class JobsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_JOBS_URL
      allow_page_roles ROLE_EXTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL_MANAGER, only: [:index, :show, :update]
      allow_page_roles Refinery::Business::ROLE_INTERNAL_FINANCE, only: [:index, :show, :update]

      before_action :find_all_jobs,  only: [:index]
      before_action :find_job,       except: [:index, :new, :create]

      helper_method :filter_params

      def index
        @jobs = @jobs.where(filter_params)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:\
        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

      def update
        if @job.update_attributes(job_params)
          flash[:notice] = 'Successfully updated the job'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.quality_assurance_job_path(@job), status: :see_other
          end
        else
          present(@page)
          render :show
        end
      end

    protected

      def jobs_scope
        @jobs ||=
            if page_role?(ROLE_INTERNAL_MANAGER)
              Job.where(nil)
            else
              Job.where('1=0')
            end
      end

      def find_all_jobs
        @jobs = jobs_scope.order(inspection_date: :desc)
      end

      def find_job
        @job = jobs_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :section_id, :assigned_to_id, :status, :billable_type, :inspection_date, :job_type, :code])
      end

      def job_params
        params.require(:job).permit(:status, :project_code, :project_label, :project_id)
      end

    end
  end
end
