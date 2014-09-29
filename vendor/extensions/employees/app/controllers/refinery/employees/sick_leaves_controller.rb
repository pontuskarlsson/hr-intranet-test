module Refinery
  module Employees
    class SickLeavesController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_all_sick_leaves
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def create
        @sick_leave = @employee.sick_leaves.build(params[:sick_leave])
        if @sick_leave.save
          flash[:info] = 'Sick Leave successfully registered.'
          redirect_to refinery.employees_sick_leaves_path
        else
          present(@page)
          render action: :index
        end
      end

      def edit
        @sick_leave = @employee.sick_leaves.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def update
        @sick_leave = @employee.sick_leaves.find(params[:id])
        if @sick_leave.update_attributes(params[:sick_leave])
          flash[:info] = 'Sick Leave successfully updated.'
          redirect_to refinery.employees_sick_leaves_path
        else
          present(@page)
          render action: :edit
        end
      end

      protected
      def find_employee
        @employee = current_refinery_user.employee
        raise ActiveRecord::RecordNotFound if @employee.nil?
      end

      def find_all_sick_leaves
        @sick_leaves = @employee.sick_leaves.order('start_date ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/employees/sick_leaves").first
      end

    end
  end
end
