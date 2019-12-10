module Refinery
  module Calendar
    class GoogleCalendar < Refinery::Core::BaseModel
      SYNC_TO_ALL_VISIBLE = 0
      SYNC_TO_ONLY_FROM_PRIMARY = 1
      SYNC_TO_NOTHING = 2
      SYNC_TO_SETTINGS = [SYNC_TO_ALL_VISIBLE, SYNC_TO_ONLY_FROM_PRIMARY, SYNC_TO_NOTHING]
      
      SYNC_FROM_EVERYTHING = 0
      SYNC_FROM_EXCEPT_PRIVATE = 1
      SYNC_FROM_NOTHING = 2
      SYNC_FROM_SETTINGS = [SYNC_FROM_EVERYTHING, SYNC_FROM_EXCEPT_PRIVATE, SYNC_FROM_NOTHING]

      belongs_to :user,             class_name: '::Refinery::Authentication::Devise::User', optional: true
      belongs_to :primary_calendar, class_name: '::Refinery::Calendar::Calendar', optional: true
      has_many :google_events,      dependent: :destroy

      attr_reader :access_code
      #attr_accessible :google_calendar_id, :user_id, :access_code, :primary_calendar_id, :sync_to_id, :sync_from_id

      validates :user_id,             presence: true
      validates :google_calendar_id,  presence: true, uniqueness: true
      validates :primary_calendar_id, presence: true, uniqueness: true
      validates :sync_to_id,          inclusion: SYNC_TO_SETTINGS
      validates :sync_from_id,        inclusion: SYNC_FROM_SETTINGS

      before_save do
        # If the Google Calendar ID has changed then we make sure that the refresh token
        # is cleared. It is a two step authentication so the ID and the Access Code will
        # never be updated at the same time.
        if changes[:google_calendar_id].present?
          self.refresh_token = nil

          # If the Access Code was supplied, then that means we should authenticate against
          # Google and retrieve the refresh token.
        elsif access_code.present?
          # Note! If +login_with_auth_code+ only returns nil, then that might be because
          # the app has already been granted permission previously. Go to google account
          # and revoke permission, then try again.
          self.refresh_token = google_client.cal.login_with_auth_code(access_code)
        end
      end

      def access_code=(value)
        if value.present?
          refresh_token_will_change!
          @access_code = value
        end
      end

      def google_authorize_url
        google_client.cal.authorize_url.to_s
      end

      def google_client
        @google_client ||= ::Refinery::Calendar::GoogleClient.new(google_calendar_id, refresh_token)
      end

      def sync_to_all_visible?
        sync_to_id == SYNC_TO_ALL_VISIBLE
      end


      class << self
        def active_sync
          where('refresh_token IS NOT NULL AND refresh_token <> ""').includes(:google_events)
        end
      end

    end
  end
end
