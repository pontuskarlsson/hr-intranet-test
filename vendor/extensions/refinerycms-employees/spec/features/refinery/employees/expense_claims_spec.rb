# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "expense_claims" do
      refinery_login_with_devise :authentication_devise_user
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

        context 'when it was created by current user' do
          before do
            other_employee = FactoryGirl.create(:employee)
            FactoryGirl.create(:xero_expense_claim, description: 'September Expenses', added_by: logged_in_user, employee: other_employee)
            FactoryGirl.create(:xero_expense_claim, description: 'October Expenses', employee: other_employee)
          end

          it 'displays expense claim from other employee' do
            visit refinery.employees_expense_claims_path

            page.should have_content('September Expenses')
            page.should_not have_content('October Expenses')
          end
        end
      end

      describe "adding new expense claim" do
        before { FactoryGirl.create(:employment_contract, employee: employee) }
        it "created an expense claim" do
          visit refinery.employees_expense_claims_path

          click_link "Add Expense Claim"

          fill_in "Description", with: "My Expenses"
          click_button "Add"

          page.should have_content("My Expenses")
        end

        context 'when adding for another employee ' do
          let(:other_employee) { FactoryGirl.create(:employee) }
          before { FactoryGirl.create(:employment_contract, employee: other_employee) }

          it 'created an expense claim' do
            visit refinery.employees_expense_claims_path

            click_link 'Add Expense Claim'

            fill_in 'Description', with: "#{other_employee.full_name}'s Expenses"
            select other_employee.full_name, from: 'For'

            click_button 'Add'

            page.should have_content("#{other_employee.full_name}'s Expenses")
          end
        end
      end

      describe 'edit' do
        let(:other_employee) { FactoryGirl.create(:employee) }
        let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: employee, description: 'A Description', added_by: logged_in_user) }
        before { FactoryGirl.create(:employment_contract, employee: other_employee) }
        it 'should succeed' do
          visit refinery.employees_expense_claim_path(xero_expense_claim)
          click_link 'Edit'

          select other_employee.full_name, from: 'For'
          fill_in 'Description', with: 'A different Description'
          click_button 'Update'

          page.should have_content('A different Description')
          page.should have_content(other_employee.full_name)
          page.should have_no_content('A Description')
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

          it "cannot be clicked" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            page.should_not have_content("Delete Expense Claim")
          end
        end
      end

      describe 'submitting expense claim' do
        before do
          employee.xero_guid = '00000-00000-555'
          employee.save!

          # Stubbing all methods that would initiate an API call to return true.
          allow_any_instance_of(::Refinery::Employees::ExpenseClaimsController).to receive(:verify_contacts) { true }
          allow_any_instance_of(::Refinery::Employees::ExpenseClaimsController).to receive(:batch_create_receipt) { true }
          allow_any_instance_of(::Refinery::Employees::ExpenseClaimsController).to receive(:attach_scanned_receipts) { true }
          allow_any_instance_of(::Refinery::Employees::ExpenseClaimsController).to receive(:submit_expense_claim) { true }
        end

        context "when it is the current user's employee" do
          let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim_with_receipts, employee: employee, status: Refinery::Employees::XeroExpenseClaim::STATUS_NOT_SUBMITTED) }

          it "succeeds" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            click_button 'Submit Expense Claim'
          end
        end

        context "when it is another employee's" do
          let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim_with_receipts, status: Refinery::Employees::XeroExpenseClaim::STATUS_NOT_SUBMITTED) }

          it "cannot be clicked" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            page.should_not have_content('Submit Expense Claim')
          end
        end
      end

    end
  end
end
