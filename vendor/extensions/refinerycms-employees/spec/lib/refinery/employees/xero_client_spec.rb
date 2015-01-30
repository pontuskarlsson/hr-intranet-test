require 'spec_helper'

module Refinery
  module Employees
    describe XeroClient do

      describe '#sync_accounts' do
        let(:xero_account) { FactoryGirl.create(:xero_account, guid: "00000000-0000-0000-1234-000000000000", name: 'Travel') }
        let(:account) { Xeroizer::Record::Account.build({ account_id: "00000000-0000-0000-1234-000000000000", name: 'Office Expense', code: '1234' }, nil) }
        it 'makes an existing XeroAccount inactive if does not find any matching Account in Xero' do
          XeroClient.any_instance.stub(:all_accounts).and_return([])

          expect(xero_account.inactive).to eq false

          expect{ XeroClient.new.sync_accounts }.to_not raise_error
          expect(xero_account.reload.inactive).to eq true
        end

        it 'creates a new XeroAccount for any Account in Xero that does not match an existing XeroAccount' do
          XeroClient.any_instance.stub(:all_accounts).and_return([account])

          expect( XeroAccount.find_by_guid(account.account_id) ).to be_nil

          expect{ XeroClient.new.sync_accounts }.to_not raise_error
          expect( XeroAccount.find_by_guid(account.account_id) ).to be_present
        end

        it 'updates an existing XeroAccount if there is a matching Account in Xero' do
          XeroClient.any_instance.stub(:all_accounts).and_return([account])

          expect( xero_account.guid ).to eq account.account_id
          expect( xero_account.name).to_not eq account.name

          expect{ XeroClient.new.sync_accounts }.to_not raise_error
          expect( xero_account.reload.name ).to eq account.name
        end
      end

      describe '#sync_contacts' do
        let(:xero_contact) { FactoryGirl.create(:xero_contact, guid: "00000000-0000-0000-1234-000000000000", name: 'Foo Bar') }
        let(:contact) { Xeroizer::Record::Contact.build({ contact_id: "00000000-0000-0000-1234-000000000000", name: 'Jane Deer' }, nil) }
        it 'makes an existing XeroContact inactive if does not find any matching Contact in Xero' do
          XeroClient.any_instance.stub(:all_contacts).and_return([])

          expect(xero_contact.inactive).to eq false

          expect{ XeroClient.new.sync_contacts }.to_not raise_error
          expect(xero_contact.reload.inactive).to eq true
        end

        it 'creates a new XeroContact for any Contact in Xero that does not match an existing XeroContact' do
          XeroClient.any_instance.stub(:all_contacts).and_return([contact])

          expect( XeroContact.find_by_guid(contact.contact_id) ).to be_nil

          expect{ XeroClient.new.sync_contacts }.to_not raise_error
          expect( XeroContact.find_by_guid(contact.contact_id) ).to be_present
        end

        it 'updates an existing XeroContact if there is a matching Contact in Xero' do
          XeroClient.any_instance.stub(:all_contacts).and_return([contact])

          expect( xero_contact.guid ).to eq contact.contact_id
          expect( xero_contact.name).to_not eq contact.name

          expect{ XeroClient.new.sync_contacts }.to_not raise_error
          expect( xero_contact.reload.name ).to eq contact.name
        end
      end

    end
  end
end
