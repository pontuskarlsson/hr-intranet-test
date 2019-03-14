# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Calendar' do
    describe 'Admin' do
      describe 'google_calendars' do
        refinery_login_with_devise :authentication_devise_user

        describe 'google calendars list' do
          before(:each) do
            FactoryGirl.create(:google_calendar, :google_calendar_id => 'UniqueTitleOne')
            FactoryGirl.create(:google_calendar, :google_calendar_id => 'UniqueTitleTwo')
          end

          it 'shows two items' do
            visit refinery.calendar_admin_google_calendars_path
            page.should have_content('UniqueTitleOne')
            page.should have_content('UniqueTitleTwo')
          end
        end

        describe 'create' do
          let(:user) { FactoryGirl.create(:authentication_devise_user) }
          let(:calendar) { FactoryGirl.create(:calendar, user: user) }
          before(:each) do
            user; calendar
            visit refinery.calendar_admin_google_calendars_path

            click_link 'Add New Google Calendar'
          end

          context 'valid data' do
            it 'should succeed' do
              fill_in 'Google Calendar ID', :with => 'This is a test of the first string field'
              select user.username, from: 'User'
              select calendar.title, from: 'Primary Calendar'
              click_button 'Save'

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Calendar::GoogleCalendar.count.should == 1
            end
          end

          context 'invalid data' do
            it 'should fail' do
              click_button 'Save'

              page.should have_content("Google Calendar ID can't be blank")
              Refinery::Calendar::GoogleCalendar.count.should == 0
            end
          end

        end

        describe 'edit' do
          before(:each) { FactoryGirl.create(:google_calendar, :google_calendar_id => 'A title') }

          it 'should succeed' do
            visit refinery.calendar_admin_google_calendars_path

            within '.actions' do
              click_link 'Edit this google calendar'
            end

            fill_in 'Google Calendar ID', :with => 'A different title'
            click_button 'Save'

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content('A title')
          end

          context 'when refresh token is missing' do
            it 'access code should be enabled' do
              visit refinery.calendar_admin_google_calendars_path

              within '.actions' do
                click_link 'Edit this google calendar'
              end

              page.should have_no_selector(:xpath, "//input[@name='google_calendar[access_code]' and @disabled='disabled']")
              page.should have_selector(:xpath, "//input[@name='google_calendar[access_code]']")
            end
          end

          context 'when refresh token is present' do
            before do
              google_calendar = ::Refinery::Calendar::GoogleCalendar.first
              google_calendar.refresh_token = 'present1token'
              google_calendar.save!
            end
            it 'access code should be disabled' do
              visit refinery.calendar_admin_google_calendars_path

              within '.actions' do
                click_link 'Edit this google calendar'
              end

              page.should have_selector(:xpath, "//input[@name='google_calendar[access_code]' and @disabled='disabled']")
            end
          end
        end

        describe 'destroy' do
          before(:each) { FactoryGirl.create(:google_calendar, :google_calendar_id => "UniqueTitleOne") }

          it 'should succeed' do
            visit refinery.calendar_admin_google_calendars_path

            click_link 'Remove this google calendar forever'

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Calendar::GoogleCalendar.count.should == 0
          end
        end

      end
    end
  end
end
