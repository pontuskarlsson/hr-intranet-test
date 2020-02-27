# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "Admin" do
      describe "number_series" do
        refinery_login

        describe "number_series list" do
          before do
            FactoryBot.create(:number_serie, :identifier => "UniqueTitleOne")
            FactoryBot.create(:number_serie, :identifier => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.business_admin_number_series_index_path
            expect( page ).to have_content("UniqueTitleOne")
            expect( page ).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.business_admin_number_series_index_path

            click_link "Add New Number Serie"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Identifier", :with => "NewIdentifier"
              click_button "Save"

              expect( page ).to have_content("was successfully added.")
              expect( Refinery::Business::NumberSerie.count ).to eq 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              expect( page ).to have_content("Identifier can't be blank")
              expect( Refinery::Business::NumberSerie.count ).to eq 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:number_serie, :identifier => "ABCDEF") }

          it "should succeed" do
            visit refinery.business_admin_number_series_index_path

            within ".actions" do
              click_link "Edit this number serie"
            end

            fill_in "Identifier", :with => "QWERTY"
            click_button "Save"

            expect( page ).to have_content("was successfully updated.")
            expect( page ).to have_no_content("ABCDEF")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:number_serie, :identifier => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.business_admin_number_series_index_path

            click_link "Remove this number serie forever"

            expect( page ).to have_content("was successfully removed.")
            expect( Refinery::Business::NumberSerie.count ).to eq 0
          end
        end

      end
    end
  end
end
