# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "requests" do
      let(:company1) { FactoryBot.create(:company) }
      let(:company2) { FactoryBot.create(:verified_company) }
      let!(:request1) { FactoryBot.create(:request, company: company1, subject: 'ABC123') }
      let!(:request2) { FactoryBot.create(:request, company: company2, subject: 'QWE456') }

      refinery_login_with_devise :authentication_devise_user

      describe "index" do
        context "when the user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          context "but does not have access to either of the companies" do
            it "does not show any of the requests" do
              visit refinery.business_requests_path

              expect( page.body ).not_to have_content("ABC123")
              expect( page.body ).not_to have_content("QWE456")
            end
          end

          context "and have access to one of the companies" do
            before { FactoryBot.create(:company_user, company: company1, user: logged_in_user) }

            it "does shows the first of the requests" do
              visit refinery.business_requests_path

              expect( page.body ).to have_content("ABC123")
              expect( page.body ).not_to have_content("QWE456")
            end
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "shows both of the requests" do
            visit refinery.business_requests_path

            expect( page.body ).to have_content("ABC123")
            expect( page.body ).to have_content("QWE456")
          end
        end
      end

      describe "show" do
        context "when the user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          context "but does not have access to the company" do
            it "does not show the first request" do
              visit refinery.business_request_path(request1)

              expect( page.body ).not_to have_content("ABC123")
            end

            it "does not show the second request" do
              visit refinery.business_request_path(request2)

              expect( page.body ).not_to have_content("QWE456")
            end
          end

          context "and have access to the company" do
            before { FactoryBot.create(:company_user, company: company1, user: logged_in_user) }

            it "does show the first request" do
              visit refinery.business_request_path(request1)

              expect( page.body ).to have_content("ABC123")
            end

            it "does not show the second request" do
              visit refinery.business_request_path(request2)

              expect( page.body ).not_to have_content("QWE456")
            end
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "does show the first request" do
            visit refinery.business_request_path(request1)

            expect( page.body ).to have_content("ABC123")
          end

          it "does show the second request" do
            visit refinery.business_request_path(request2)

            expect( page.body ).to have_content("QWE456")
          end
        end
      end

      describe "creating a request" do
        context "when the user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          context "and have access to an unverified company" do
            before { FactoryBot.create(:company_user, company: company1, user: logged_in_user) }

            before {
              visit refinery.business_requests_path
              click_link "New Request"
            }

            it "should not have a select for requested by" do
              expect( page ).not_to have_select("Requested By")
            end

            it "creates a new request" do
              expect {
                fill_in "Subject", :with => "This is a test Subject"
                fill_in "Description", :with => "This is a test Description"
                select "Inspection", :from => "Type"

                click_button "Send"
              }.to change { company1.requests.count }.by 1
            end
          end

          context "and have access to a verified company" do
            before { FactoryBot.create(:company_user, company: company2, user: logged_in_user) }

            before {
              visit refinery.business_requests_path
              click_link "New Request"
            }

            it "should not have a select for requested by" do
              expect( page ).not_to have_select("Requested By")
            end

            it "creates a new request" do
              expect {
                fill_in "Subject", :with => "This is a test Subject"
                fill_in "Description", :with => "This is a test Description"
                select "Inspection", :from => "Type"

                click_button "Send"
              }.to change { company2.requests.count }.by 1
            end
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }
          let!(:external_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }
          before { FactoryBot.create(:company_user, company: company1, user: external_user) }

          before {
            Warden.on_next_request do |proxy|
              proxy.raw_session[:selected_company_uuid] = company1.uuid
            end
            visit refinery.business_requests_path
            click_link "New Request"
          }

          it "should have a select for requested by" do
            expect( page ).to have_select("Requested By")
          end

          it "creates a new request" do
            expect {
              select external_user.label, :from => "Requested By"
              fill_in "Subject", :with => "This is a test Subject"
              fill_in "Description", :with => "This is a test Description"
              select "Inspection", :from => "Type"

              click_button "Send"
            }.to change { company1.requests.count }.by 1
          end
        end
      end
    end
  end
end
