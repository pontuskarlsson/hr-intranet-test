window.Refinery ?= {}
Refinery.Business ?= {}
Refinery.Business.Budgets =

  # Helper methods called from within this file only
  _wrapInSuffix: (suffix, $node) ->
    $cont = $("<div class=\"row collapse\"><div class=\"small-9 columns\"></div><div class=\"small-3 columns\"><span class=\"postfix\" style=\"font-size: 0.6rem;\">#{suffix}</span></div></div>")
    $('.small-9', $cont).append($node)
    $cont.prop 'outerHTML'

  _formatCurrency: (data) ->
    val = parseFloat(data).toFixed(2).toString()
    if val.substr(-2, 2) == '00'
      val = val.substr(0, val.length - 3)
    val.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")


  # Functiona and callbacks related to the DataTable for Budgets
  budgetDataTable:
    columns:
      description: (data, type, row, meta) ->
        "<a href=\"/business/budgets/#{row.id}\">#{data}</a>"

      customerName: (data, type, row, meta) ->
        if row.customer_contact_id?
          "<a href=\"/marketing/contacts/#{row.customer_contact_id}\">#{data}</a>"
        else
          data

      no_of_products: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

      no_of_skus: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

      price: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

      quantity: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

      total_quantity: (data, type, row, meta) -> # data here is same as for quantity, so we calculate this column manually
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data * row.no_of_skus)).prop 'outerHTML'

      total: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

      marginPercent: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text("#{Refinery.Business.Budgets._formatCurrency(data)}%").prop 'outerHTML'

      marginTotal: (data, type, row, meta) ->
        $('<div style="text-align: right;"></div>').text(Refinery.Business.Budgets._formatCurrency(data)).prop 'outerHTML'

    callbacks:
      draw: ->
        api = @api()

        products_col = api.column(4, { page: 'current' })
        $(products_col.footer()).html($('<div style="text-align: right;"></div>').text('Sum: '+products_col.data().sum()).prop('outerHTML'))

        skus_col = api.column(5, { page: 'current' })
        $(skus_col.footer()).html($('<div style="text-align: right;"></div>').text('Sum: '+skus_col.data().sum()).prop('outerHTML'))

        total_col = api.column(9, { page: 'current' })
        $(total_col.footer()).html($('<div style="text-align: right;"></div>').text('Sum: '+ Refinery.Business.Budgets._formatCurrency(total_col.data().sum())).prop('outerHTML'))

        mar_tot_col = api.column(11, { page: 'current' })
        $(mar_tot_col.footer()).html($('<div style="text-align: right;"></div>').text('Sum: '+Refinery.Business.Budgets._formatCurrency(mar_tot_col.data().sum())).prop('outerHTML'))

        qty_col = api.column(7, { page: 'current' })
        price_col = api.column(6, { page: 'current' })
        qty = 0
        for val, i in skus_col.data()
          qty += val * qty_col.data()[i]
        $(price_col.footer()).html($('<div style="text-align: right;"></div>').text('Avg: '+ Refinery.Business.Budgets._formatCurrency(total_col.data().sum() / qty)).prop('outerHTML'))

        tot_qty_col = api.column(8, { page: 'current' })
        $(tot_qty_col.footer()).html($('<div style="text-align: right;"></div>').text('Sum: '+Refinery.Business.Budgets._formatCurrency(qty)).prop('outerHTML'))

        margin_col = api.column(10, { page: 'current' })
        if total_col.data().sum() == 0
          $(margin_col.footer()).html($('<div style="text-align: right;"></div>').text('Avg: 0%').prop('outerHTML'))
        else
          $(margin_col.footer()).html($('<div style="text-align: right;"></div>').text('Avg: '+ Refinery.Business.Budgets._formatCurrency(100.0 * mar_tot_col.data().sum() / total_col.data().sum()) + '%').prop('outerHTML'))

        if skus_col.data().sum() == 0
          $(qty_col.footer()).html($('<div style="text-align: right;"></div>').text('Avg: N/A').prop('outerHTML'))
        else
          $(qty_col.footer()).html($('<div style="text-align: right;"></div>').text('Avg: '+Refinery.Business.Budgets._formatCurrency(qty / skus_col.data().sum())).prop('outerHTML'))


  # Functiona and callbacks related to the DataTable for BudgetItems
  budgetItemsDataTable:
    columns:
      description: (data, type, row, meta) ->
        $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][description]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        ).prop 'outerHTML'

      noOfProducts: (data, type, row, meta) ->
        $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][no_of_products]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        ).prop 'outerHTML'

      noOfSkus: (data, type, row, meta) ->
        $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][no_of_skus]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        ).prop 'outerHTML'

      price: (data, type, row, meta) ->
        Refinery.Business.Budgets._wrapInSuffix '$', $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][price]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        )

      quantity: (data, type, row, meta) ->
        $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][quantity]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        ).prop 'outerHTML'

      total: (data, type, row, meta) ->
        $('<span class="js_budget_item_total"></span>').html( Refinery.Business.Budgets._formatCurrency(data) ).prop('outerHTML')

      marginPercent: (data, type, row, meta) ->
        Refinery.Business.Budgets._wrapInSuffix '%', $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][margin_percent]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        )

      marginTotal: (data, type, row, meta) ->
        $('<span class="js_budget_item_margin_total"></span>').html( Refinery.Business.Budgets._formatCurrency(data) ).prop('outerHTML')

      comments: (data, type, row, meta) ->
        $('<input>',
          name: "budget[budget_items_attributes][#{meta.row}][comments]"
          value: data
          type: 'text'
          class: "js_budget_item_field"
          'data-row': meta.row
          'data-col': meta.col
        ).prop 'outerHTML'

      id: (data, type, row, meta) ->
        if data == null
          ''
        else
          "<input type=\"hidden\" name=\"budget[budget_items_attributes][#{meta.row}][id]\" value=\"#{data}\"/>"+
          "<input type=\"hidden\" name=\"budget[budget_items_attributes][#{meta.row}][_destroy]\" data-row=\"#{meta.row}\" value=\"0\"/>"+
          "<a href=\"#\" class=\"js_budget_item_remove\"  data-row=\"#{meta.row}\">Remove</a>"


    events:
      formFieldChange: (evt) ->
        $field = $(evt.target)
        row = $field.data('row')
        col = $field.data('col')
        api = $field.parents('.dataTable').DataTable()
        val = $field.prop('value')
        api.cell(row, col).data(val)

        api.cell(row, 5).data(parseFloat(api.cell(row, 4).data()) * parseFloat(api.cell(row, 3).data()) * parseFloat(api.cell(row, 2).data()));
        api.cell(row, 7).data(parseFloat(api.cell(row, 4).data()) * parseFloat(api.cell(row, 3).data()) * parseFloat(api.cell(row, 2).data()) * parseFloat(api.cell(row, 6).data()) / 100.0);

        api.draw()

      removeClick: (evt) ->
        evt.preventDefault()
        $link = $(evt.target)
        row = $link.data('row')
        $(".js_budget_item_field[data-row=#{row}]").prop('disabled', 'disabled')
        $("[name=\"budget[budget_items_attributes][#{row}][_destroy]\"]").prop('value', '1')

        $link.text('Undo').attr('class', 'js_budget_item_undo')

      undoClick: (evt) ->
        evt.preventDefault()
        $link = $(evt.target)
        row = $link.data('row')
        $(".js_budget_item_field[data-row=#{row}]").prop('disabled', '')
        $("[name=\"budget[budget_items_attributes][#{row}][_destroy]\"]").prop('value', '0')

        $link.text('Remove').attr('class', 'js_budget_item_remove')


    callbacks:
      draw: ->
        api = @api()

        products_col = api.column(1, { page: 'current' })
        $(products_col.footer()).html('Sum: '+products_col.data().sum())

        skus_col = api.column(2, { page: 'current' })
        $(skus_col.footer()).html('Sum: '+skus_col.data().sum())

        qty_col = api.column(4, { page: 'current' })
        $(qty_col.footer()).html('Sum: '+qty_col.data().sum())

        total_col = api.column(5, { page: 'current' })
        $(total_col.footer()).html('Sum: '+ Refinery.Business.Budgets._formatCurrency(total_col.data().sum()))

        mar_tot_col = api.column(7, { page: 'current' })
        $(mar_tot_col.footer()).html('Sum: '+ Refinery.Business.Budgets._formatCurrency(mar_tot_col.data().sum()))
