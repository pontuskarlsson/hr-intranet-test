module Refinery
  module QualityAssurance
    class QualityAssuranceController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_DASHBOARD_URL

      helper_method :has_qa_content?, :recent_inspections

      def dashboard

      end

      protected

      def credits_scope
        @credits_scope ||= ::Refinery::Business::Voucher.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def inspections_scope
        @inspections_scope ||= Inspection.for_selected_company(selected_company).for_user_roles(current_refinery_user)
        @inspections_scope_test ||= Inspection.for_selected_company(selected_company).for_user_roles_test(current_refinery_user)

        if @inspections_scope.map(&:id) != @inspections_scope_test.map(&:id)
          ErrorMailer.webhook_notification_email('+for_user_roles+ mismatch', params.to_unsafe_h).deliver_later
        end

        @inspections_scope
      end

      def jobs_scope
        @jobs ||= Job.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def has_qa_content?
        if current_refinery_user.has_role? ROLE_EXTERNAL
          inspections_scope.exists?
        else
          true
        end
      end

      def recent_inspections
        inspections_scope.recent(5)
      end

      def server_side?
        params.has_key? :draw
      end

    end
  end
end
