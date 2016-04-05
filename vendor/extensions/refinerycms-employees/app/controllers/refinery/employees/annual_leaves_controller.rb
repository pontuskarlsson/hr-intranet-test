module Refinery
  module Employees
    class AnnualLeavesController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_all_annual_leaves,    only: [:index]
      before_filter :find_annual_leave,         except: [:index, :create, :approve, :reject]
      before_filter :find_approvable_loa,       only: [:approve, :reject]
      before_filter :find_page

      def index
        @leave_of_absence = @employee.leave_of_absences.build
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def create
        @leave_of_absence = @employee.leave_of_absences.build({ status: ::Refinery::Employees::LeaveOfAbsence::STATUS_WAITING_FOR_APPROVAL }.reverse_merge(params[:leave_of_absence] || {}))
        if @leave_of_absence.save
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
        if @leave_of_absence.update_attributes(params[:leave_of_absence])
          flash[:notice] = 'Annual Leave successfully updated.'
          redirect_to refinery.employees_annual_leaves_path
        else
          present(@page)
          render action: :edit
        end
      end

      def approve
        if @leave_of_absence.update_attributes(status: ::Refinery::Employees::LeaveOfAbsence::STATUS_APPROVED)
          flash[:notice] = 'Leave of Absence successfully approved.'
        else
          flash[:notice] = 'Leave of Absence could not be approved.'
        end
        redirect_to refinery.employees_annual_leaves_path
      end

      def reject
        if @leave_of_absence.update_attributes(status: ::Refinery::Employees::LeaveOfAbsence::STATUS_REJECTED)
          flash[:notice] = 'Leave of Absence successfully rejected.'
        else
          flash[:notice] = 'Leave of Absence could not be rejected.'
        end
        redirect_to refinery.employees_annual_leaves_path
      end

      def destroy
        if @leave_of_absence.destroy
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
        @leave_of_absences = @employee.leave_of_absences.non_sick_leaves.order('start_date DESC')
        @employee_loas = ::Refinery::Employees::LeaveOfAbsence.approvable_by(@employee).order('status ASC, start_date DESC').includes(:employee)
      end

      def find_annual_leave
        @leave_of_absence = @employee.leave_of_absences.non_sick_leaves.find(params[:id])
      end

      def find_approvable_loa
        @leave_of_absence = ::Refinery::Employees::LeaveOfAbsence.approvable_by(@employee).find(params[:id])
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/employees/annual_leaves").first
      end

    end
  end
end
