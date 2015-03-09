Refinery::User.class_eval do
  has_many :google_calendars,   class_name: '::Refinery::Calendar::GoogleCalendar', dependent: :destroy

  def calendar_user_attribute
    send(Refinery::Calendar.user_attribute_reference)
  end

end
