module Refinery
  module Business
    class BudgetsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_BUDGETS_URL
      allow_page_roles ROLE_INTERNAL

      before_action :find_all_budgets
      before_action :find_budget, except: [:index, :new, :create]

      def index
        present(@page)
      end

      def new
        @budget_form = BudgetForm.new_in_model(Budget.new)
        present(@page)
      end

      def create
        @budget_form = BudgetForm.new_in_model(Budget.new, params[:budget], current_refinery_user)
        if @budget_form.save
          redirect_to refinery.business_budget_path(@budget_form.budget)
        else
          present(@page)
          render action: :new
        end
      end

      def show
        present(@page)
      end

      def update
        if @budget.budget_form(params[:budget], current_refinery_user).save
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

      def find_budget
        @budget = Budget.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
