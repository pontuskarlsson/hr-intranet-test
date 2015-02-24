do ($ = jQuery, _ = @._) ->
  $ ->

    # Changing template interpolate to Mustache style
    _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g

    # Template for a Line Item form row
    lineItemTmpl = $('.js_line_item_tmpl').html()

    $('.js_add_line_item').click ->
      $("<div class=\"js_line_item line-item\">#{lineItemTmpl}</div>").insertBefore('.js_line_item_tmpl')

    $('body').on 'click', '.js_remove_line_item', (event) ->
      $(event.target).parents('.js_line_item').first().remove()
