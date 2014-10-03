do ($ = jQuery, _ = @._) ->
  $ ->

    # Changing template interpolate to Mustache style
    _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g

    # Template for a Line Item form row
    lineItemTmpl = $('.js_line_item_tmpl').html()

    $('.js_add_line_item').click ->
      $("<div class=\"row\">#{lineItemTmpl}</div>").prependTo('.js_new_line_anchor')

    $('body').on 'click', '.js_remove_line_item', (event) ->
      $row = $(event.target).parents('.row').first()
      $row.remove()
