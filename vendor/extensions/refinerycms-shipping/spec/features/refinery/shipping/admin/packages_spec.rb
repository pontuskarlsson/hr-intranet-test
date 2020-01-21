# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Shipping" do
    describe "Admin" do
      describe "packages" do
        refinery_login_with_devise :authentication_devise_user

        describe "packages list" do
          before do
            FactoryBot.create(:package, :account_no => "12345")
            FactoryBot.create(:package, :account_no => "54321")
          end

          it "shows two items" do
            visit refinery.shipping_admin_packages_path
            page.should have_content("12345")
            page.should have_content("54321")
          end
        end

        describe "create" do
          let(:contact) { FactoryBot.create(:contact) }
          before do
            contact # Creates one record before loading form

            visit refinery.shipping_admin_packages_path

            click_link "Add New Shipment Account"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Contact", :with => contact.name
              fill_in "Account No", :with => "98765"
              fill_in "Courier", :with => "DHLExpress"
              fill_in "Description", :with => "DHL Account for #{contact.name}"
              click_button "Save"

              page.should have_content("'DHL Account for #{contact.name}' was successfully added.")
              Refinery::Shipping::Package.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Account No can't be blank")
              Refinery::Shipping::Package.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:package, description: 'A Description') }

          it "should succeed" do
            visit refinery.shipping_admin_packages_path

            within ".actions" do
              click_link "Edit this shipment account"
            end

            fill_in "Description", :with => "Another Description"
            click_button "Save"

            page.should have_content("'Another Description' was successfully updated.")
            page.should have_no_content("A Description")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:package, :description => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.shipping_admin_packages_path

            click_link "Remove this shipment account forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Shipping::Package.count.should == 0
          end
        end

      end
    end
  end
end
