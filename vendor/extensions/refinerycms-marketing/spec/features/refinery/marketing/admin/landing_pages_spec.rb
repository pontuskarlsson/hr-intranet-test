# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Marketing" do
    describe "Admin" do
      describe "landing_pages" do
        refinery_login

        describe "landing pages list" do
          before do
            FactoryBot.create(:landing_page, :title => "UniqueTitleOne")
            FactoryBot.create(:landing_page, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.marketing_admin_landing_pages_path
            expect( page ).to have_content("UniqueTitleOne")
            expect( page ).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.marketing_admin_landing_pages_path

            click_link "Add New Landing Page"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "New Landing Page"
              fill_in "Slug", :with => "/new_landing_page"

              expect{
                click_button "Save"
              }.to change{ Refinery::Page.count }.by 1


              expect( page ).to have_content("'New Landing Page' was successfully added.")
              expect( Refinery::Marketing::LandingPage.count ).to eq 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              expect( page ).to have_content("Title can't be blank")
              expect( Refinery::Marketing::LandingPage.count ).to eq 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:landing_page, :title => "A name") }

          it "should succeed" do
            visit refinery.marketing_admin_landing_pages_path

            within ".actions" do
              click_link "Edit this landing page"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            expect( page ).to have_content("'A different name' was successfully updated.")
            expect( page ).to have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:landing_page, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.marketing_admin_landing_pages_path
            click_link "Remove this landing page forever"

            expect( page ).to have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Marketing::Contact.count.should == 0
          end
        end

      end
    end
  end
end
