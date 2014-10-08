module Refinery
  module Employees
    class SickLeavesController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_all_sick_leaves,  only: [:index]
      before_filter :find_sick_leave,       except: [:index, :create]
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
        if @sick_leave.update_attributes(params[:sick_leave])
          flash[:info] = 'Sick Leave successfully updated.'
          redirect_to refinery.employees_sick_leaves_path
        else
          present(@page)
          render action: :edit
        end
      end

      def add_note
        @resource = @sick_leave.build_doctors_note
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
        @sick_leave = @employee.sick_leaves.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        redirect_to '/'
      end

      def find_all_sick_leaves
        @sick_leaves = @employee.sick_leaves.includes(:doctors_note).order('start_date ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/employees/sick_leaves").first
      end

      def create_and_associate_resource
        begin
          SickLeave.transaction do
            @resources = ::Refinery::Resource.create_resources(params[:resource])
            @resource = @resources.detect { |r| r.valid? } || (raise ::ActiveRecord::RecordNotSaved)

            @sick_leave.doctors_note = @resource
            @sick_leave.save!

            true
          end
        rescue ::ActiveRecord::RecordNotSaved
          false
        end
      end

    end
  end
end
