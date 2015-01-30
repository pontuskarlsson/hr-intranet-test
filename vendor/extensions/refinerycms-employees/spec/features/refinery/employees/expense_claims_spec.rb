# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "expense_claims" do
      refinery_login_with :refinery_user
      before(:each) do
        FactoryGirl.create(:employee, user: logged_in_user)
      end
      let(:employee) { logged_in_user.employee }

      describe "list of expense claims" do
        context "when expense claims are present" do
          before do
            FactoryGirl.create(:xero_expense_claim, description: 'September Expenses', employee: employee)
            FactoryGirl.create(:xero_expense_claim, description: 'October Expenses', employee: employee, status: Refinery::Employees::XeroExpenseClaim::STATUS_SUBMITTED)
          end

          it "shows two items" do
            visit refinery.employees_expense_claims_path

            page.should have_content('September Expenses')
            page.should have_content('October Expenses')
          end
        end

        context "when there are no expense claims" do
          it "displays an empty list" do
            visit refinery.employees_expense_claims_path

            page.should have_content('Add Expense Claim')
          end
        end
      end

      describe "adding new expense claim" do
        it "created an expense claim" do
          visit refinery.employees_expense_claims_path

          click_link "Add Expense Claim"

          fill_in "Description", with: "My Expenses"
          click_button "Add"

          page.should have_content("My Expenses")
        end
      end

      describe "removing expense claim" do
        context "when it is not submitted" do
          let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: employee, status: Refinery::Employees::XeroExpenseClaim::STATUS_NOT_SUBMITTED) }

          it "succeeds" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            click_button "Delete Expense Claim"

            expect( ::Refinery::Employees::XeroExpenseClaim.count ).to eq 0
          end
        end

        context "when it is submitted" do
          let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: employee, status: Refinery::Employees::XeroExpenseClaim::STATUS_SUBMITTED) }

          it "succeeds" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            page.should_not have_content("Delete Expense Claim")
          end
        end
      end

    end
  end
end
