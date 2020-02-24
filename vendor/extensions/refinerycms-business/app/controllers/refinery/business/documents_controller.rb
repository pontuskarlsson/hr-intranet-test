module Refinery
  module Business
    class DocumentsController < ::ApplicationController
      before_action :find_company

      def new
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@company, params[:document], current_refinery_user)
      end

      def create
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@company, params[:document], current_refinery_user)
        unless @document_creator.save
          render action: :new
        end
      end

      protected

      def company_scope
        @companies ||= Company.for_user_roles(current_refinery_user)
      end

      def find_company
        @company = company_scope.find(params[:company_id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
