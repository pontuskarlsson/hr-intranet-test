# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "QualityAssurance" do
    describe "causes" do
      refinery_login_with_devise :authentication_devise_user

      describe "index" do
        context "when user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL,
              ::Refinery::QualityAssurance::ROLE_INTERNAL,
          ]) }

          context "and there are no causes" do
            it "should show the page" do
              visit refinery.quality_assurance_causes_path

              expect( page.body ).to have_content("Causes")
            end
          end

          context "and there are causes" do
            let!(:cause) { FactoryBot.create(:cause) }

            it "should show the page" do
              visit refinery.quality_assurance_causes_path

              expect( page.body ).to have_content("Causes")
            end
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }

          context "and there are no causes" do
            it "should show the page" do
              visit refinery.quality_assurance_causes_path

              expect( page.body ).to have_content("Causes")
            end
          end

          context "and there are causes" do
            let!(:cause) { FactoryBot.create(:cause) }

            it "should show the page" do
              visit refinery.quality_assurance_causes_path

              expect( page.body ).to have_content("Causes")
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

          let!(:cause) { FactoryBot.create(:cause) }

          it "should show the page" do
            visit refinery.quality_assurance_cause_path(cause)

            expect( page.body ).not_to have_content("Page not found")
            expect( page.body ).to have_content("Causes")
          end
        end

        context "when user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL,
              ::Refinery::QualityAssurance::ROLE_EXTERNAL,
          ]) }

          context "and there are causes" do
            let!(:cause) { FactoryBot.create(:cause) }

            it "should show the page" do
              visit refinery.quality_assurance_cause_path(cause)

              expect( page.body ).not_to have_content("Page not found")
              expect( page.body ).to have_content("Causes")
            end
          end
        end
      end
    end
  end
end
