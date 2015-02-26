# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Calendar' do
    describe 'events' do
      before { Refinery::Calendar::Engine.load_seed }
      refinery_login_with :refinery_user

      describe 'events list' do
        context 'when events are in public calendars' do
          before(:each) do
            FactoryGirl.create(:event, title: 'UniqueTitleOne')
            FactoryGirl.create(:event, title: 'UniqueTitleTwo')
          end

          it 'shows two items' do
            visit refinery.calendar_events_path
            page.should have_content('UniqueTitleOne')
            page.should have_content('UniqueTitleTwo')
          end
        end

        context 'when events are in private calendar' do
          before(:each) do
            calendar = FactoryGirl.create(:calendar, user: logged_in_user, private: true)
            FactoryGirl.create(:event, title: 'UniqueTitleOne', calendar: calendar)
            calendar = FactoryGirl.create(:calendar, private: true, user: FactoryGirl.create(:refinery_user))
            FactoryGirl.create(:event, title: 'UniqueTitleTwo', calendar: calendar)
          end

          it 'only shows events from own private calendar' do
            visit refinery.calendar_events_path
            page.should have_content('UniqueTitleOne')
            page.should_not have_content('UniqueTitleTwo')
          end
        end

      end

      describe 'create' do
        let(:calendar) { FactoryGirl.create(:calendar) }
        before(:each) do
          calendar
          visit refinery.calendar_events_path

          click_link 'Add Event'
        end

        context 'valid data' do
          it 'should succeed' do
            fill_in 'Title', with: 'This is a test of the first string field'
            fill_in 'From', with: '2013-01-02 09:03:00 UTC'

            click_button 'Create Event'

            page.should have_content('This is a test of the first string field')
            Refinery::Calendar::Event.count.should == 1
          end
        end
      end

      describe 'edit' do
        before(:each) { FactoryGirl.create(:event, :title => 'A title') }

        it 'should succeed' do
          pending 'Not implemented'
          visit refinery.calendar_events_path

          within '.actions' do
            click_link 'Edit this event'
          end

          fill_in 'Title', :with => 'A different title'
          click_button 'Save'

          page.should have_content('A different title')
          page.should have_no_content('A title')
        end
      end

      describe 'destroy' do
        before(:each) { FactoryGirl.create(:event, :title => 'UniqueTitleOne') }

        it 'should succeed' do
          pending 'Not implemented'
          visit refinery.calendar_events_path

          click_link 'Remove this event forever'

          page.should have_content("'UniqueTitleOne' was successfully removed.")
          Refinery::Calendar::Event.count.should == 0
        end
      end

    end
  end
end
