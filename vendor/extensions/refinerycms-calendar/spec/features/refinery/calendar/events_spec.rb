# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Calendar' do
    describe 'events' do
      before { Refinery::Calendar::Engine.load_seed }
      refinery_login_with_devise :authentication_devise_user

      describe 'events list' do
        context 'when events are in public calendars' do
          before(:each) do
            FactoryBot.create(:event, title: 'UniqueTitleOne')
            FactoryBot.create(:event, title: 'UniqueTitleTwo')
          end

          it 'shows two items' do
            visit refinery.calendar_events_path
            page.should have_content('UniqueTitleOne')
            page.should have_content('UniqueTitleTwo')
          end
        end

        context 'when events are in private calendar' do
          before(:each) do
            calendar = FactoryBot.create(:calendar, user: logged_in_user, private: true)
            FactoryBot.create(:event, title: 'UniqueTitleOne', calendar: calendar)
            calendar = FactoryBot.create(:calendar, private: true, user: FactoryBot.create(:authentication_devise_user))
            FactoryBot.create(:event, title: 'UniqueTitleTwo', calendar: calendar)
          end

          it 'only shows events from own private calendar' do
            visit refinery.calendar_events_path
            page.should have_content('UniqueTitleOne')
            page.should_not have_content('UniqueTitleTwo')
          end
        end

      end

      describe 'create' do
        let(:calendar) { FactoryBot.create(:calendar) }
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
        context 'when it is from users own calendar' do
          let(:event) { FactoryBot.create(:event,  title: 'A title',
                                                    calendar: FactoryBot.create(:calendar, user: logged_in_user)) }
          it 'should succeed' do
            visit refinery.calendar_event_path(event)
            click_link 'Edit Details'

            fill_in 'Title', :with => 'A different title'
            click_button 'Update Event'

            page.should have_content('A different title')
            page.should have_no_content('A title')
          end
        end

        context 'when it is not from users own calendar' do
          let(:event) { FactoryBot.create(:event,  title: 'A title') }
          it 'should not be able to edit' do
            visit refinery.calendar_event_path(event)
            page.should have_no_content('Edit Details')
          end
        end
      end

      describe 'destroy' do
        context 'when it is from users own calendar' do
          let(:event) { FactoryBot.create(:event, calendar: FactoryBot.create(:calendar, user: logged_in_user)) }
          it 'should succeed' do
            visit refinery.calendar_event_path(event)
            click_link 'Remove Event'

            ::Refinery::Calendar::Event.count.should eq 0
          end
        end

        context 'when it is not from users own calendar' do
          let(:event) { FactoryBot.create(:event) }
          it 'should not be able to remove' do
            visit refinery.calendar_event_path(event)
            page.should have_no_content('Remove Event')
          end
        end
      end

    end
  end
end
