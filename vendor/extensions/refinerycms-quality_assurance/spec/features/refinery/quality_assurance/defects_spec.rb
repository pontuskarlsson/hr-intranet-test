# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "QualityAssurance" do
    describe "defects" do
      refinery_login_with_devise :authentication_devise_user

      describe "index" do
        context "when user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL,
              ::Refinery::QualityAssurance::ROLE_INTERNAL,
          ]) }

          context "and there are no defects" do
            it "should show the page" do
              visit refinery.quality_assurance_defects_path

              expect( page.body ).to have_content("Defects")
            end
          end

          context "and there are defects" do
            let!(:defect) { FactoryBot.create(:defect) }

            it "should show the page" do
              visit refinery.quality_assurance_defects_path

              expect( page.body ).to have_content("Defects")
            end
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }

          context "and there are no defects" do
            it "should show the page" do
              visit refinery.quality_assurance_defects_path

              expect( page.body ).to have_content("Defects")
            end
          end

          context "and there are defects" do
            let!(:defect) { FactoryBot.create(:defect) }

            it "should show the page" do
              visit refinery.quality_assurance_defects_path

              expect( page.body ).to have_content("Defects")
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

          let!(:defect) { FactoryBot.create(:defect) }

          it "should show the page" do
            visit refinery.quality_assurance_defect_path(defect)

            expect( page.body ).not_to have_content("Page not found")
            expect( page.body ).to have_content("Defects")
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }

          context "and there are defects" do
            let!(:defect) { FactoryBot.create(:defect) }

            it "should show the page" do
              visit refinery.quality_assurance_defect_path(defect)

              expect( page.body ).not_to have_content("Page not found")
              expect( page.body ).to have_content("Defects")
            end
          end
        end
      end
    end
  end
end
