module Refinery
  module Employees
    class SickLeavesController < ::Refinery::Employees::ApplicationController
      set_page PAGE_SICK_LEAVES

      before_action :find_employee
      before_action :find_all_sick_leaves,  only: [:index]
      before_action :find_sick_leave,       except: [:index, :new, :create]

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def new
        @leave_of_absence = @employee.leave_of_absences.sick_leaves.build
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def create
        @leave_of_absence = @employee.leave_of_absences.sick_leaves.build(leave_of_absence_param)
        if @leave_of_absence.save
          flash[:notice] = 'Sick Leave successfully registered.'
          redirect_to refinery.employees_sick_leaves_path
        else
          find_all_sick_leaves
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
        if @leave_of_absence.update_attributes(leave_of_absence_param)
          flash[:notice] = 'Sick Leave successfully updated.'
          redirect_to refinery.employees_sick_leaves_path
        else
          present(@page)
          render action: :edit
        end
      end

      def extend
        if @leave_of_absence.update_attributes(end_date: Date.today)
          flash[:notice] = 'Sick Leave successfully extended.'
        else
          flash[:alert] = 'Failed to extend Sick Leave.'
        end
        redirect_to refinery.employees_sick_leaves_path
      end

      def destroy
        if @leave_of_absence.destroy
          flash[:notice] = 'Successfully removed the Sick Leave'
        else
          flash[:alert] = 'Failed to remove the Sick Leave'
        end
        redirect_to refinery.employees_sick_leaves_path
      end

      def add_note
        @resource = @leave_of_absence.build_doctors_note
      end

      def create_note
        if create_and_associate_resource
          flash[:notice] = 'Successfully added Doctors note'
        else
          flash[:alert] = 'Failed to add Doctors note'
        end
        redirect_to refinery.employees_sick_leaves_path
      end

      protected
      def find_employee
        @employee = current_refinery_user.employee
        raise ActiveRecord::RecordNotFound if @employee.nil?
      end

      def find_sick_leave
        @leave_of_absence = @employee.leave_of_absences.sick_leaves.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        redirect_to '/'
      end

      def find_all_sick_leaves
        @leave_of_absences = @employee.leave_of_absences.sick_leaves.includes(:doctors_note).order('start_date ASC')
      end

      def create_and_associate_resource
        begin
          LeaveOfAbsence.transaction do
            @resources = ::Refinery::Resource.create_resources(params[:resource])
            @resource = @resources.detect { |r| r.valid? } || (raise ::ActiveRecord::RecordNotSaved)

            @leave_of_absence.doctors_note = @resource
            @leave_of_absence.save!

            true
          end
        rescue ::ActiveRecord::RecordNotSaved
          false
        end
      end

      def leave_of_absence_param
        params.require(:leave_of_absence).permit(:start_date, :start_half_day, :end_date, :end_half_day, :i_am_sick_today)
      end

    end
  end
end
