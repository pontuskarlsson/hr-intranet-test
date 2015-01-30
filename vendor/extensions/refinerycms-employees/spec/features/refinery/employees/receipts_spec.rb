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
      let(:xero_expense_claim) { FactoryGirl.create(:xero_expense_claim, employee: employee) }

      describe "adding new receipt" do
        before(:each) do
          FactoryGirl.create(:xero_contact)
          FactoryGirl.create(:xero_account)
        end
        let(:xero_contact) { ::Refinery::Employees::XeroContact.first }
        let(:xero_account) { ::Refinery::Employees::XeroAccount.first }

        context "when expense claim is not submitted" do
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
      end


    end
  end
end
