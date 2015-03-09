# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Employees' do
    describe 'Admin' do
      describe 'xero_accounts' do
        refinery_login_with :refinery_user

        describe 'xero_accounts list' do
          before do
            FactoryGirl.create(:xero_account, code: '9912')
            FactoryGirl.create(:xero_account, code: '8854')
          end

          it 'shows two items' do
            visit refinery.employees_admin_xero_accounts_path
            page.should have_content('9912')
            page.should have_content('8854')
          end
        end

        describe 'edit' do
          before { FactoryGirl.create(:xero_account, code: '5431') }

          it 'should succeed' do
            visit refinery.employees_admin_xero_accounts_path

            within '.actions' do
              click_link 'Edit this xero account'
            end

            check 'Featured'
            fill_in 'When to use', with: 'Use when...'
            click_button 'Save'

            page.should have_content("'5431' was successfully updated.")

            expect( ::Refinery::Employees::XeroAccount.last.when_to_use ).to eq 'Use when...'
            expect( ::Refinery::Employees::XeroAccount.last.featured ).to eq true
          end
        end

      end
    end
  end
end
