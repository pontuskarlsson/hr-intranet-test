module Refinery
  module Business
    class CompaniesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_COMPANIES_URL
      allow_page_roles ROLE_EXTERNAL, only: [:index, :show, :shipments]
      allow_page_roles ROLE_INTERNAL

      before_filter :find_companies, only: [:index]
      before_filter :find_company,  except: [:index, :new, :create]

      def index
        @companies = @companies.includes(:contact).order(code: :asc)
        @company = Company.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def shipments
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def create
        @company = Company.new(company_params)
        if @company.save
          redirect_to refinery.business_company_path @company
        else
          find_companies
          @companies = @companies.order(code: :asc)
          present(@page)
          render :index
        end
      end

      protected

      def company_scope
        @companies ||=
            if page_role? ROLE_INTERNAL
              Refinery::Business::Company.where(nil)
            elsif page_role? ROLE_EXTERNAL
              current_authentication_devise_user.companies
            else
              Refinery::Business::Company.where('1=0')
            end
      end

      def find_companies
        if company_scope.size == 1
          redirect_to refinery.business_company_path(company_scope[0])
        else
          @companies = company_scope
        end
      end

      def find_company
        @company = company_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def company_params
        params.require(:company).permit(:name)
      end

    end
  end
end
