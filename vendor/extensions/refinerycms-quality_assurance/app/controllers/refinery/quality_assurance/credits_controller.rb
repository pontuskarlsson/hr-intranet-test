module Refinery
  module QualityAssurance
    class CreditsController < QualityAssuranceController
      include Refinery::PageRoles::AuthController

      set_page PAGE_CREDITS_URL

      allow_page_roles ::Refinery::Business::ROLE_EXTERNAL, only: [:index]
      #allow_page_roles ::Refinery::Business::ROLE_INTERNAL, only: [:index]

      before_action :find_all_credits,  only: [:index]

      helper_method :filter_params, :purchase

      def index
        @credits = @credits.where(filter_params)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:\
        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      protected

      def find_all_credits
        @credits = credits_scope
      end

      def filter_params
        params.permit([:company_id]).to_h
      end

      def purchase
        @purchase ||= ::Refinery::Business::Purchase.new(article_code: 'VOUCHER-QAQC-DAY')
      end

    end
  end
end
