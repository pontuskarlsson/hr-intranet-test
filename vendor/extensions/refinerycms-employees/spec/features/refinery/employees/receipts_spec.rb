# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "receipts" do
      refinery_login_with :refinery_user
      before(:each) do
        FactoryGirl.create(:employee, user: logged_in_user)
      end
      let(:employee) { logged_in_user.employee }
      let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: employee, added_by: logged_in_user) }

      describe "adding new receipt" do
        let(:xero_contact) { FactoryGirl.create(:xero_contact) }
        let(:xero_account) { FactoryGirl.create(:xero_account) }
        let(:xero_tracking_category) { FactoryGirl.create(:xero_tracking_category) }
        before(:each) do
          xero_contact
          xero_account
          xero_tracking_category
        end

        context "when expense claim is not submitted" do
          it "succeeds" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            click_link "Add Receipt"

            fill_in "From", with: xero_contact.name
            fill_in "Date", with: "2014-10-23"
            fill_in "xero_receipt[xero_line_items_attributes][0][description]", with: "Coca-Cola"
            select xero_account.code_and_name, from: "xero_receipt[xero_line_items_attributes][0][xero_account_id]"
            fill_in "xero_receipt[xero_line_items_attributes][0][quantity]", with: '783'
            fill_in "xero_receipt[xero_line_items_attributes][0][unit_amount]", with: '99.99'
            select xero_tracking_category.options[1][:name], from: "xero_receipt[xero_line_items_attributes][0][tracking_categories_and_options][#{xero_tracking_category.guid}]"
            click_button "Save"

            page.should have_content(xero_contact.name)
            page.should have_content('Coca-Cola')
            page.should have_content('783')
            page.should have_content('99.99')
            page.should have_content(xero_tracking_category.options[1][:name])
            ::Refinery::Employees::XeroReceipt.count.should eq 1
            ::Refinery::Employees::XeroLineItem.count.should eq 1
          end
        end

        context 'when expense claim is added by current user but for another employee' do
          let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: FactoryGirl.create(:employee), added_by: logged_in_user) }

          it "succeeds" do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            click_link "Add Receipt"

            fill_in "From", with: xero_contact.name
            fill_in "Date", with: "2014-10-23"
            fill_in "xero_receipt[xero_line_items_attributes][0][description]", with: "Coca-Cola"
            select xero_account.code_and_name, from: "xero_receipt[xero_line_items_attributes][0][xero_account_id]"
            fill_in "xero_receipt[xero_line_items_attributes][0][quantity]", with: '1'
            fill_in "xero_receipt[xero_line_items_attributes][0][unit_amount]", with: '10'
            click_button "Save"

            page.should have_content(xero_contact.name)
            ::Refinery::Employees::XeroReceipt.count.should eq 1
            ::Refinery::Employees::XeroLineItem.count.should eq 1
          end
        end

        context 'when pressing the Save & Add another button' do
          it 'takes you to the form again after having created the Receipt' do
            visit refinery.employees_expense_claim_path(xero_expense_claim)

            click_link 'Add Receipt'

            fill_in 'From', with: xero_contact.name
            fill_in 'Date', with: '2014-10-23'
            fill_in 'xero_receipt[xero_line_items_attributes][0][description]', with: 'Coca-Cola'
            select xero_account.code_and_name, from: 'xero_receipt[xero_line_items_attributes][0][xero_account_id]'
            fill_in 'xero_receipt[xero_line_items_attributes][0][quantity]', with: '783'
            fill_in 'xero_receipt[xero_line_items_attributes][0][unit_amount]', with: '99.99'
            click_button 'Save & Add another'

            page.should have_content('Add Receipt')
            ::Refinery::Employees::XeroReceipt.count.should eq 1
            ::Refinery::Employees::XeroLineItem.count.should eq 1
          end
        end
      end

      describe 'removing line items from receipt' do
        let(:xero_receipt) { FactoryGirl.create(:xero_receipt_with_line_items, xero_expense_claim: xero_expense_claim) }
        before(:each) do
          xero_receipt
        end

        context 'when there is one line item present' do
          it 'succeeds and updates total on receipt and expense claim' do
            visit refinery.edit_employees_expense_claim_receipt_path(xero_receipt.xero_expense_claim, xero_receipt)

            check 'xero_receipt[xero_line_items_attributes][0][_destroy]'
            click_button 'Save'

            xero_receipt.reload.xero_line_items.should be_empty
            xero_receipt.total.should eq 0
            xero_receipt.xero_expense_claim.total.should eq 0
          end
        end
      end

      describe 'removing receipt' do
        context 'when it is not submitted' do
          let(:xero_receipt) { FactoryGirl.create(:xero_receipt, xero_expense_claim: xero_expense_claim) }

          it 'succeeds' do
            visit refinery.employees_expense_claim_receipt_path(xero_receipt.xero_expense_claim, xero_receipt)

            click_button 'Delete Receipt'

            expect( ::Refinery::Employees::XeroReceipt.count ).to eq 0
          end
        end

        context 'when it is submitted' do
          let(:xero_receipt) { FactoryGirl.create(:xero_receipt, xero_expense_claim: xero_expense_claim, status: Refinery::Employees::XeroReceipt::STATUS_SUBMITTED) }

          it 'cannot be clicked' do
            visit refinery.employees_expense_claim_receipt_path(xero_receipt.xero_expense_claim, xero_receipt)

            page.should_not have_content('Delete Receipt')
            page.should have_content('Cannot Delete when submitted')
          end
        end
      end

    end
  end
end
