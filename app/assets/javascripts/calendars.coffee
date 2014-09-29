do ($ = jQuery) ->
  $ ->

    $('.js_calendar_inactive').click ->
      checkbox = $(@)
      checkbox.parents('form').first().submit()

      if checkbox.is(':checked')
        $('[data-calendar-id="'+checkbox.data('inactivate-id')+'"]').css('display', '')
      else
        $('[data-calendar-id="'+checkbox.data('inactivate-id')+'"]').css('display', 'none')
