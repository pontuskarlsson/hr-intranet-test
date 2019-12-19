class RestHook < ApplicationRecord
  INSPECTION_NEW = 'new_inspection'

  class_attribute :_registered_events, instance_writer: false

  belongs_to :user, class_name: '::Refinery::Authentication::Devise::User'

  serialize :scope, Hash

  validates :event_name,  inclusion: { in: -> (r) { r.registered_events } }

  # Trigger method always returns the hooks that apply, even if they
  # were triggered (production) or not (dev & test).
  #
  def self.trigger(event_name, encoded_record)
    hooks = where(event_name: event_name)
    return if hooks.empty?

    return hooks unless Rails.env.production?

    # Trigger each hook
    hooks.each do |hook|
      RestClient.post(hook.hook_url, encoded_record) do |response|
        hook.destroy if response.code.eql? 410
      end
    end
  end

  def registered_events
    self._registered_events || []
  end

  def self.register_event(event_name)
    self._registered_events ||= []

    raise 'duplicate event names' if _registered_events.include? event_name.to_s

    _registered_events << event_name.to_s
  end

  register_event INSPECTION_NEW

end
