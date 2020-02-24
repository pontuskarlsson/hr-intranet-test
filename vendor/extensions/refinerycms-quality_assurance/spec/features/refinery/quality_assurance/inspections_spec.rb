# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "QualityAssurance" do
    describe "inspections" do
      refinery_login_with_devise :authentication_devise_user

      describe "index" do
        context "when user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL,
              ::Refinery::QualityAssurance::ROLE_INTERNAL,
          ]) }

          context "and there are no inspections" do
            it "should show the page" do
              visit refinery.quality_assurance_inspections_path

              expect( page.body ).to have_content("Inspections")
            end
          end

          context "and there are inspections" do
            let!(:inspection) { FactoryBot.create(:inspection) }

            it "should show the page" do
              visit refinery.quality_assurance_inspections_path

              expect( page.body ).to have_content("Inspections")
            end
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }
          let!(:company) { FactoryBot.create(:verified_company) }
          before { FactoryBot.create(:company_user, company: company, user: logged_in_user) }

          context "and there are no inspections" do
            it "should show the page" do
              visit refinery.quality_assurance_inspections_path

              expect( page.body ).to have_content("Inspections")
            end
          end

          context "and there are inspections, but not for the users company" do
            let!(:inspection) { FactoryBot.create(:inspection) }

            it "should show the page" do
              visit refinery.quality_assurance_inspections_path

              expect( page.body ).to have_content("Inspections")
            end
          end

          context "and there are inspections for the users company" do
            let!(:inspection) { FactoryBot.create(:inspection, company: company) }

            it "should show the page" do
              visit refinery.quality_assurance_inspections_path

              expect( page.body ).to have_content("Inspections")
            end
          end
        end
      end

      describe "show" do
        context "when user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL,
              ::Refinery::QualityAssurance::ROLE_INTERNAL,
          ]) }

          let!(:inspection) { FactoryBot.create(:inspection) }

          it "should show the page" do
            visit refinery.quality_assurance_inspection_path(inspection)

            expect( page.body ).not_to have_content("Page not found")
            expect( page.body ).to have_content("Inspections")
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }
          let!(:company) { FactoryBot.create(:verified_company) }
          before { FactoryBot.create(:company_user, company: company, user: logged_in_user) }

          context "for an inspection but not for the users company" do
            let!(:inspection) { FactoryBot.create(:inspection) }

            it "should show the not found page" do
              visit refinery.quality_assurance_inspection_path(inspection)

              expect( page.body ).to have_content("Page not found")
              expect( page.status_code ).to eq 404
            end
          end

          context "and there are inspections for the users company" do
            let!(:inspection) { FactoryBot.create(:inspection, company: company) }

            it "should show the page" do
              visit refinery.quality_assurance_inspection_path(inspection)

              expect( page.body ).not_to have_content("Page not found")
              expect( page.body ).to have_content("Inspections")
            end
          end
        end
      end
    end
  end
end
