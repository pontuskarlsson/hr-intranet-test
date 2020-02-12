module Refinery
  module Business
    class ConfirmContractJob < Struct.new(:plan_id, :user_id)

      attr_accessor :plan

      # def enqueue(job)
      #
      # end

      def perform
        @plan = ::Refinery::Business::Plan.find plan_id

        # pdf_content = generate_pdf
        #
        # resource = create_resource_from pdf_content, "#{@plan.reference} #{@plan.company&.name}.pdf"
        #
        # document = @plan.company.documents.create!(
        #     resource_id: resource.id,
        #     document_type: 'contract'
        # )
        #
        # @plan.contract = document
        # @plan.save!

      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        ActivityNotification::Notification.notify_all notify_users.to_a, @plan, key: 'plan.confirmed'
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      # def failure(job)
      #
      # end

      private

      def generate_pdf
        # create an instance of ActionView, so we can use the render method outside of a controller
        av = ActionView::Base.new
        av.view_paths = ActionController::Base.view_paths

        # need these in case your view constructs any links or references any helper methods.
        av.class_eval do
          include Rails.application.routes.url_helpers
          include ApplicationHelper
        end

        # Make instance variables available inside render
        p = plan
        av.instance_eval do
          @plan = p
        end

        pdf_html = av.render template: 'refinery/business/plans/contract',
                             layout: 'layouts/pdf/document_layout',
                             header: { spacing: 5, html: { template: 'pdf/plans/contract_header', layout: 'layouts/pdf/header_layout', locals: { company: plan.company } } },
                             footer: { spacing: 5, html: { template: 'pdf/plans/contract_footer', layout: 'layouts/pdf/footer_layout', locals: { account: plan.account } } },
                             margin: { top: 68, bottom: 32, right: 10, left: 20 }

        # use wicked_pdf gem to create PDF from the doc HTML
        WickedPdf.new.pdf_from_string(pdf_html, :page_size => 'A4')
      end

      def create_resource_from(file_content, file_name)
        resource = Refinery::Resource.new
        resource.file = file_content
        resource.file.name = file_name
        resource.authorizations_access = Refinery::Resource.access_string_for(
            Refinery::Business::ROLE_EXTERNAL => { company_id: plan.company_id},
            Refinery::Business::ROLE_INTERNAL => { company_id: plan.company_id}
        )
        resource.save!
        resource
      end

      def notify_users
        Refinery::Authentication::Devise::User.where(id: user_id).to_a +
            Refinery::Authentication::Devise::User.for_role('Superuser').to_a
      end

    end
  end
end
