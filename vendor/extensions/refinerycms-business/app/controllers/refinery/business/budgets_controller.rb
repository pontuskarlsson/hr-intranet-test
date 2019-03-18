module Refinery
  module Business
    class BudgetsController < ::ApplicationController

      before_filter :find_all_budgets
      before_filter :find_page
      before_filter :find_budget, except: [:index, :new, :create]

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @sales_order in the line below:
        present(@page)
      end

      def new
        @budget_form = BudgetForm.new_in_model(Budget.new)
        present(@page)
      end

      def create
        @budget_form = BudgetForm.new_in_model(Budget.new, params[:budget], current_authentication_devise_user)
        if @budget_form.save
          redirect_to refinery.business_budget_path(@budget_form.budget)
        else
          present(@page)
          render action: :new
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @sales_order in the line below:
        present(@page)
      end

      def update
        if @budget.budget_form(params[:budget], current_authentication_devise_user).save
          flash[:notice] = 'Successfully updated the Budget'
          redirect_to refinery.business_budget_path(@budget)
        else
          present(@page)
          render action: :show
        end
      end

      protected

      def find_all_budgets
        @budgets = Budget.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/business/budgets', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def find_budget
        @budget = Budget.find(params[:id])
      end

    end
  end
end
