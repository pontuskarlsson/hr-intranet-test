window.Refinery ?= {}
Refinery.Business ?= {}
Refinery.Business.Budgets =

  # Helper methods called from within this file only
  _wrapInSuffix: (suffix, $node) ->
    $cont = $("<div class=\"row collapse\"><div class=\"small-9 columns\"></div><div class=\"small-3 columns\"><span class=\"postfix\" style=\"font-size: 0.6rem;\">#{suffix}</span></div></div>")
    $('.small-9', $cont).append($node)
    $cont.prop 'outerHTML'

  _formatCurrency: (data) ->
    parseFloat(data).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")


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

      price: (data, type, row, meta) ->
        Refinery.Business.Budgets._formatCurrency(data)

      total: (data, type, row, meta) ->
        Refinery.Business.Budgets._formatCurrency(data)

      marginPercent: (data, type, row, meta) ->
        "#{data}%"

      marginTotal: (data, type, row, meta) ->
        Refinery.Business.Budgets._formatCurrency(data)

    callbacks:
      draw: ->
        api = @api()

        products_col = api.column(4, { page: 'current' })
        $(products_col.footer()).html('Sum: '+products_col.data().sum())

        skus_col = api.column(5, { page: 'current' })
        $(skus_col.footer()).html('Sum: '+skus_col.data().sum())

        qty_col = api.column(7, { page: 'current' })
        $(qty_col.footer()).html('Sum: '+qty_col.data().sum())

        total_col = api.column(8, { page: 'current' })
        $(total_col.footer()).html('Sum: '+ Refinery.Business.Budgets._formatCurrency(total_col.data().sum()))

        mar_tot_col = api.column(10, { page: 'current' })
        $(mar_tot_col.footer()).html('Sum: '+ Refinery.Business.Budgets._formatCurrency(mar_tot_col.data().sum()))


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
