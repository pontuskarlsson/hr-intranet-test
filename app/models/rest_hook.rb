class RestHook < ApplicationRecord
  INSPECTION_NEW = 'new_inspection'

  class_attribute :_registered_events, instance_writer: false

  belongs_to :user, class_name: '::Refinery::Authentication::Devise::User'

  serialize :scope, Hash

  validates :user_id,     presence: true
  validates :event_name,  inclusion: -> { registered_events }

  def registered_events
    self._registered_events || []
  end

  def self.register_event(event_name)
    _registered_events ||= []

    raise 'duplicate event names' if _registered_events.include? event_name.to_s

    _registered_events << event_name.to_s
  end

  register_event INSPECTION_NEW

end
