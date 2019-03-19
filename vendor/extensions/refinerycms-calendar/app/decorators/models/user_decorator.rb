Refinery::Authentication::Devise::User.class_eval do
  has_many :google_calendars,   class_name: '::Refinery::Calendar::GoogleCalendar', dependent: :destroy

end
