module Refinery
  module Business
    class CompaniesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_COMPANIES_URL
      allow_page_roles ROLE_EXTERNAL
      allow_page_roles ROLE_INTERNAL

      before_action :find_companies, only: [:index]
      before_action :find_company,  except: [:index, :new, :create, :unselect]

      helper_method :new_company

      def index
        @companies = @companies.includes(:contact)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @companies.dt_response(params) if server_side?
          }
        end
      end

      def unselect
        unselect_company!

        redirect_to portal_root_url
      end

      def new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @company in the line below:
        present(@page)
      end

      def select
        select_company!(@company)

        redirect_to portal_root_url
      end

      def create
        @company = Company.new(company_params)

        if @company.save
          if current_refinery_user.has_role?(::Refinery::Business::ROLE_INTERNAL)
            @company.verified_at = DateTime.now
            @company.verified_by = current_refinery_user
          else
            @company.company_users.create(user: current_refinery_user, role: 'Owner')

          end

          redirect_to refinery.business_company_path @company
        else
          render action: :new
        end
      end

      def add_document
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@company)
      end

      def create_document
        @document_creator = ::Refinery::Business::DocumentCreator.new_in_model(@company, params[:document], current_refinery_user)
        if @document_creator.save
          flash[:notice] = 'Successfully added Document(s)'
        else
          flash[:alert] = 'Failed to add Document(s)'
        end
        redirect_to refinery.shipping_shipment_path(@shipment)
      end

      protected

      def company_scope
        @companies ||= Company.for_user_roles(current_refinery_user, @auth_role_titles)
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

      def new_company
        @company ||= Company.new
      end

    end
  end
end
