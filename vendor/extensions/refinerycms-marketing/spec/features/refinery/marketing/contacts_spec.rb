# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Marketing" do
    describe "contacts" do
      refinery_login_with_devise :authentication_devise_user

      describe "contact list" do
        before(:each) do
          FactoryBot.create(:contact, name: 'Unique Name 1')
          FactoryBot.create(:contact, name: 'Unique Name 2')
        end

        context "when the user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          it "does not list any contacts" do
            visit refinery.marketing_contacts_path

            expect( page ).not_to have_content("Loading, please wait...")
            expect( page ).to have_content("The page you requested was not found")
            expect( page ).to have_http_status 404
          end
        end

        context "when the user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "shows a table that will load the contacts" do
            visit refinery.marketing_contacts_path

            expect( page ).to have_content("Loading, please wait...")
            expect( page ).not_to have_content("The page you requested was not found")
            expect( page ).to have_http_status 200
          end
        end

      end

      describe "contact details" do
        let!(:contact) { FactoryBot.create(:contact) }

        context "when the user is external" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          it "does not display the contact details" do
            visit refinery.marketing_contact_path(contact)

            expect( page ).not_to have_content(contact.name)
            expect( page ).not_to have_content(contact.email)
            expect( page ).to have_http_status 404
          end
        end

        context "when the user is internal" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "displays the details of a specific contact" do
            visit refinery.marketing_contact_path(contact)

            expect( page ).to have_content(contact.name)
            expect( page ).to have_content(contact.email)
            expect( page ).to have_http_status 200
          end

          context "when other contacts has same tags" do
            before(:each) do
              FactoryBot.create(:contact, name: 'Similar contact 1', tags_joined_by_comma: contact.tags_joined_by_comma)
              FactoryBot.create(:contact, name: 'Similar contact 2', tags_joined_by_comma: contact.tags_joined_by_comma)
              FactoryBot.create(:contact, name: 'Not the same tags 1', tags_joined_by_comma: 'unlikely, different')
            end

            it "displays a list of similar contacts" do
              visit refinery.marketing_contact_path(contact)

              expect( page ).to have_content('Similar contact 1')
              expect( page ).to have_content('Similar contact 2')
              expect( page ).not_to have_content('Not the same tags 1')
            end
          end

          context "when contact is organisation" do
            let(:contact) { FactoryBot.create(:contact, is_organisation: true) }
            before(:each) do
              FactoryBot.create(:contact, name: 'John Doe', organisation: contact)
              FactoryBot.create(:contact, name: 'Bruce Wayne', organisation: contact)
              FactoryBot.create(:contact, name: 'Clark Kent')
            end

            it "displays a list of employees" do
              visit refinery.marketing_contact_path(contact)

              expect( page ).to have_content('John Doe')
              expect( page ).to have_content('Bruce Wayne')
              expect( page ).not_to have_content('Clark Kent')
            end
          end
        end
      end

    end
  end
end
