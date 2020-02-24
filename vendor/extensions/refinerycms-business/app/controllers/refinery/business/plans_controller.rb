module Refinery
  module Business
    class PlansController < ::ApplicationController
      before_action :find_plans, only: [:index]
      before_action :find_plan,  except: [:index, :create]

      helper_method :confirm_plan_form

      def index
        @plans = @plans.from_params(params).order(reference: :asc)
      end

      def show
      end

      def update
        if false # @plan.update_attributes(plan_params)
          flash[:notice] = 'Successfully updated the Plan'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.business_plan_path(@plan), status: :see_other
          end
        else
          render :edit
        end
      end

      def contract
        respond_to do |format|
          format.html
          format.pdf {
            render contract_pdf_options
          }
        end
      end

      def confirm
        respond_to do |format|
          if confirm_plan_form.save
            pdf_html = render_to_string contract_pdf_options
            resource = create_resource_from pdf_html, "#{@plan.reference} #{@plan.company&.name}.pdf"
            document = @plan.company.documents.create!(
                resource_id: resource.id,
                document_type: 'contract'
            )
            @plan.contract = document
            @plan.save!
            Delayed::Job.enqueue(ConfirmContractJob.new(@plan.id, current_refinery_user.id))
            format.html { redirect_to refinery.business_plan_path(@plan) }
          else
            format.html { render action: :show }
          end
        end
      end

      protected

      def plan_scope
        @plans ||= Refinery::Business::Plan.for_user_roles(current_refinery_user)
      end

      def find_plans
        @plans = plan_scope.where(filter_params)
      end

      def find_plan
        @plan = plan_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :status]).to_h
      end

      def confirm_plan_form
        @confirm_plan_form ||= ConfirmPlanForm.new_in_model(@plan, params[:plan], current_refinery_user)
      end

      def contract_pdf_options
        {
            pdf: "#{@plan.reference} #{@plan.company&.name}",
            formats: :pdf,
            template: 'refinery/business/plans/contract',
            layout: 'pdf/document_layout',
            header: { spacing: 5, html: { template: 'pdf/plans/contract_header', layout: 'pdf/header_layout', locals: { company: @plan.company } } },
            footer: { spacing: 5, html: { template: 'pdf/plans/contract_footer', layout: 'pdf/footer_layout', locals: { account: @plan.account } } },
            margin: { top: 68, bottom: 32, right: 10, left: 20 }
        }
      end

      def create_resource_from(file_content, file_name)
        resource = Refinery::Resource.new
        resource.file = file_content
        resource.file.name = file_name
        resource.file_mime_type = resource.file.mime_type
        resource.authorizations_access = Refinery::Resource.access_string_for(
            Refinery::Business::ROLE_EXTERNAL => { company_id: @plan.company_id},
            Refinery::Business::ROLE_INTERNAL => { company_id: @plan.company_id}
        )
        resource.save!
        resource
      end

    end
  end
end
