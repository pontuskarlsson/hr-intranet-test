module Refinery
  module Employees
    class AnnualLeavesController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_all_annual_leaves,    only: [:index]
      before_filter :find_annual_leave,         except: [:index, :create]
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def create
        @annual_leave = @employee.annual_leaves.build(params[:annual_leave])
        if @annual_leave.save
          flash[:notice] = 'Annual Leave successfully registered.'
          redirect_to refinery.employees_annual_leaves_path
        else
          find_all_annual_leaves
          present(@page)
          render action: :index
        end
      end

      def edit
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def update
        if @annual_leave.update_attributes(params[:annual_leave])
          flash[:notice] = 'Annual Leave successfully updated.'
          redirect_to refinery.employees_annual_leaves_path
        else
          present(@page)
          render action: :edit
        end
      end

      def destroy
        if @annual_leave.destroy
          flash[:notice] = 'Successfully removed the Annual Leave'
        else
          flash[:alert] = 'Failed to remove the Annual Leave'
        end
        redirect_to refinery.employees_annual_leaves_path
      end

      protected
      def find_employee
        @employee = current_refinery_user.employee
        raise ActiveRecord::RecordNotFound if @employee.nil?
      end

      def find_all_annual_leaves
        @annual_leaves = @employee.annual_leaves.order('start_date ASC')
      end

      def find_annual_leave
        @annual_leave = @employee.annual_leaves.find(params[:id])
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/employees/annual_leaves").first
      end

    end
  end
end
