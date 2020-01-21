# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Marketing" do
    describe "contacts" do

      describe "contact list" do
        before(:each) do
          FactoryBot.create(:contact, name: 'Unique Name 1')
          FactoryBot.create(:contact, name: 'Unique Name 2')
        end

        it "displays a list of contacts" do
          visit refinery.marketing_contacts_path

          page.should have_content("Unique Name 1")
          page.should have_content("Unique Name 2")
        end

      end

      describe "contact details" do
        let(:contact) { FactoryBot.create(:contact) }

        it "displays the details of a specific contact" do
          visit refinery.marketing_contact_path(contact)

          page.should have_content(contact.name)
          page.should have_content(contact.email)
        end

        context "when other contacts has same tags" do
          before(:each) do
            FactoryBot.create(:contact, name: 'Similar contact 1', tags_joined_by_comma: contact.tags_joined_by_comma)
            FactoryBot.create(:contact, name: 'Similar contact 2', tags_joined_by_comma: contact.tags_joined_by_comma)
            FactoryBot.create(:contact, name: 'Not the same tags 1', tags_joined_by_comma: 'unlikely, different')
          end
          it "displays a list of similar contacts" do
            visit refinery.marketing_contact_path(contact)

            page.should have_content('Similar contact 1')
            page.should have_content('Similar contact 2')
            page.should_not have_content('Not the same tags 1')
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

            page.should have_content('John Doe')
            page.should have_content('Bruce Wayne')
            page.should_not have_content('Clark Kent')
          end
        end

      end

    end
  end
end
