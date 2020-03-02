module Refinery
  module Business
    class SectionsController < BusinessController
      include Refinery::PageRoles::AuthController

      set_page PAGE_PROJECTS_URL

      allow_page_roles ROLE_INTERNAL

      before_action :find_project

      def create
        @section = @project.sections.build(section_params)
        if @section.save
          flash[:notice] = 'Successfully added a section'
        else
          flash[:alert] = 'Failed to add a section'
        end
        redirect_to refinery.business_project_path(@project), status: :see_other
      end

      def show
        present(@page)
      end

      def update
        # if @billable.billable_form(params[:billable], current_refinery_user).save
        #   flash[:notice] = 'Successfully updated the Billable'
        #   redirect_to refinery.business_billable_path(@billable)
        # else
        #   present(@page)
        #   render action: :show
        # end
      end

      protected

      def find_project
        @project = projects_scope.find(params[:project_id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def find_section
        @section = @project.sections.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def section_params
        params.require(:section).permit(:description, :section_type)
      end
      
    end
  end
end
