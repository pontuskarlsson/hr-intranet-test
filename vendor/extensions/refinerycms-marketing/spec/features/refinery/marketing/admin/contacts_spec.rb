# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Marketing" do
    describe "Admin" do
      describe "contacts" do
        refinery_login_with :refinery_user

        describe "contacts list" do
          before do
            FactoryGirl.create(:contact, :name => "UniqueTitleOne")
            FactoryGirl.create(:contact, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.marketing_admin_contacts_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.marketing_admin_contacts_path

            click_link "Add New Contact"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Base", :with => "1234"
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Marketing::Contact.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Base can't be blank")
              Refinery::Marketing::Contact.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:contact, :name => "A name") }

          it "should succeed" do
            visit refinery.marketing_admin_contacts_path

            within ".actions" do
              click_link "Edit this contact"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:contact, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.marketing_admin_contacts_path

            click_link "Remove this contact forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Marketing::Contact.count.should == 0
          end
        end

      end
    end
  end
end
