module Refinery
  module Business
    class CompaniesController < ::ApplicationController

      before_filter :find_page
      before_filter :find_companies, only: [:index]
      before_filter :find_company,  except: [:index]

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      protected

      def find_companies
        if current_authentication_devise_user.companies.size == 1
          redirect_to refinery.business_company_path(current_authentication_devise_user.companies[0])
        else
          @companies = current_authentication_devise_user.companies
        end
      end

      def find_company
        @company = current_authentication_devise_user.companies.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/business/companies', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
