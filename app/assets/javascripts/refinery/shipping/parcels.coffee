window.Refinery ?= {}
Refinery.Shipping ?= {}
Refinery.Shipping.Parcels =

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
  parcelsDataTable:
    columns:
      id: (data, type, row, meta) ->
        $("<a href=\"/shipping/parcels/#{row.id}\">View</a>").prop 'outerHTML'

      from_name: (data, type, row, meta) ->
        if row.from_contact_id?
          $("<a href=\"/marketing/contacts/#{row.from_contact_id}\"></a>").text(data).prop 'outerHTML'
        else
          data
