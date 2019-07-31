module Refinery
  module Business
    class ProjectsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_PROJECTS_URL
      allow_page_roles ROLE_EXTERNAL, only: [:index, :archive, :show]
      allow_page_roles ROLE_INTERNAL

      before_filter :find_projects, only: [:index, :archive]
      before_filter :find_project,  except: [:index, :archive, :create]

      def index
        @projects = @projects.current.where(filter_params).order(code: :asc)
        @project = Project.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        present(@page)
      end

      def archive
        @projects = @projects.past.where(filter_params).order(code: :asc)
        @project = Project.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
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

      protected

      def project_scope
        @projects ||=
            if page_role? ROLE_INTERNAL
              Refinery::Business::Project.where(nil)
            elsif page_role? ROLE_EXTERNAL
              current_authentication_devise_user.projects
            else
              Refinery::Business::Project.where('1=0')
            end
      end

      def find_projects
        @projects = project_scope
      end

      def find_project
        @project = project_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def project_params
        params.require(:project).permit(:company_label, :description, :end_date, :start_date, :status)
      end

      def filter_params
        params.permit([:company_id, :status])
      end

    end
  end
end
