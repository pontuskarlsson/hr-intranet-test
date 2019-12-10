module Refinery
  module Calendar
    class GoogleEvent < Refinery::Core::BaseModel
      belongs_to :google_calendar, optional: true
      belongs_to :event, optional: true

      #attr_accessible :google_event_id, :last_synced_at, :event_id

      validates :google_calendar_id,  presence: true
      validates :event_id,            presence: true, uniqueness: { scope: :google_calendar_id }
      validates :google_event_id,     presence: true

    end
  end
end
