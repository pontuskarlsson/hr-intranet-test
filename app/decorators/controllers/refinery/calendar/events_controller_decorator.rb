Refinery::Calendar::EventsController.class_eval do

  def show
    if @event.calendar.allows_event_update_by?(current_refinery_user)
      render partial: 'modal_edit', locals: { event: @event }
    else
      render partial: 'modal_show', locals: { event: @event }
    end
  end

end
