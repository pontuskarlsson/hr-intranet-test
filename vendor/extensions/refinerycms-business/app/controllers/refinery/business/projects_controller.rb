module Refinery
  module Business
    class ProjectsController < BusinessController
      include Refinery::PageRoles::AuthController

      set_page PAGE_PROJECTS_URL

      allow_page_roles ROLE_EXTERNAL, only: [:index, :show]
      allow_page_roles ROLE_INTERNAL
      allow_page_roles ROLE_INTERNAL_FINANCE

      before_action :find_projects, only: [:index]
      before_action :find_project,  except: [:index, :create]

      def index
        @projects = @projects.from_params(params).order(code: :asc)

        @project = Project.new

        present(@page)
      end

      def create
        @project = Project.new(project_params)
        if @project.save
          redirect_to refinery.business_project_path @project
        else
          find_projects
          @projects = @projects.order(code: :asc)
          present(@page)
          render :index
        end
      end

      def show
        @section = ::Refinery::Business::Section.new(project_id: @project.id)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        present(@page)
      end

      def edit
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        present(@page)
      end

      def update
        if @project.update_attributes(project_params)
          flash[:notice] = 'Successfully updated the Project'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.business_project_path(@project), status: :see_other
          end
        else
          present(@page)
          render :edit
        end
      end

      protected

      def find_projects
        @projects = projects_scope.where(filter_params)
      end

      def find_project
        @project = projects_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def project_params
        params.require(:project).permit(:code, :company_label, :company_reference, :description, :end_date, :start_date, :status)
      end

      def filter_params
        params.permit([:company_id, :status]).to_h
      end

    end
  end
end
