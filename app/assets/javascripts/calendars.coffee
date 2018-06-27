do ($ = jQuery) ->
  $ ->

    setCalendarHeights = ->
      $('.row.calendar-row').map((i, row) ->
        $cells = $('.calendar-day', row);

        # Reset the previously set min-height
        $cells.css('min-height', '')

        # Determine the max height of the cells in the row
        height = $cells.toArray().reduce((height, el) ->
          Math.max($(el).outerHeight(), height)
        , 0)

        # Set the same height to all cells in row
        $cells.css('min-height', "#{height}px")
      )


    $('.js_calendar_inactive').click ->
      checkbox = $(@)
      checkbox.parents('form').first().submit()

      if checkbox.is(':checked')
        $('[data-calendar-id="'+checkbox.data('inactivate-id')+'"]').css('display', '')
      else
        $('[data-calendar-id="'+checkbox.data('inactivate-id')+'"]').css('display', 'none')

      # Recalculate after calenders have been added or removed
      setTimeout(setCalendarHeights, 1)

    # Calculate on page load
    setCalendarHeights()
