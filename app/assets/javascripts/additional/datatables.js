// A Function to create and attach a dropdown button
// to show and hide columns from the data table.
//
function initDataTable(dt, ajaxStatus, hasSelect) {
  initDataTableMenu(dt, ajaxStatus, hasSelect);
  initDataTableHeaders(dt);
  initDataTableRowClick(dt, hasSelect)
}

function initDataTableMenu(dt, ajaxStatus, hasSelect) {
  var $toolbar = $('.extra-toolbar', dt.table().container());

  if (ajaxStatus) {
    var $statusButtons = $('<span style="margin-left: 5px;"><span>Data: </span></span>');
    Object.keys(ajaxStatus).forEach(function(key, i) {
      var $button = $('<button class="dt-button'+(ajaxStatus[key] ? ' active' : '')+'" data-status="'+key+'"'+(i === 0 ? ' style="margin-right: -1px;"' : '')+'></button>');
      $button.html(key[0].toUpperCase()+key.slice(1));
      $button.on('click', function() {
        ajaxStatus[key] = !ajaxStatus[key];
        $button.toggleClass('active');
        dt.ajax.reload();
      });
      $button.appendTo($statusButtons);
    });
    $toolbar.prepend($statusButtons);
  }

  var tmplButton = '<button class="dt-button" type="button" data-toggle="data-table-dropdown">Columns <i class="fa fa-caret-down"></i></button>';
  var tmplMenu = '<div class="dropdown-pane" id="data-table-dropdown" data-dropdown data-auto-focus="true"><h5>Visible Columns</h5><ul class="menu vertical"></ul></div>';
  var tmplItem = '<li><label class="switch"><input type="checkbox" /><span class="switch-slider round"></span></label></li>';

  var $button = $(tmplButton);
  var $menu = $(tmplMenu);

  dt.columns().every(function(colIndex) {
    if (colIndex === 0 || (hasSelect && colIndex === 1)) return;

    // Create column item
    var col = dt.column(colIndex);
    var $item = $(tmplItem);

    // Configure item
    $item.append(' '+$(col.header()).html());
    $('input', $item).attr('checked', col.visible());
    $('input', $item).data('col-index', colIndex);

    // Add to menu
    $('.menu', $menu).append($item);
  });

  $toolbar.prepend($menu);
  $toolbar.prepend($button);

  new Foundation.Dropdown($menu, {});

  // Show/Hide columns och input change event
  $menu.on('change', 'input', function() {
    var col = dt.column($(this).data('col-index'));
    col.visible(!col.visible());
    dt.columns.adjust();
  });
}

function initDataTableHeaders(dt) {
   var dateFilters = [];

  dt.columns().every(function() {
    var col = this;
    var $h = $(col.header());

    if ($h.data('dt-search-input')) {
      var $input = $('<input type="text" />').attr('placeholder', $h.html());
      var $hidden = $('<div class="hidden-title"></div>').html($h.html());
      $h.html($hidden).append($input)

    } else if ($h.data('dt-search-date')) {
      dateFilters.push(col.index())
      var $input = $('<input type="text" class="dt-date" />').attr('placeholder', $h.html());
      var $hidden = $('<div class="hidden-title"></div>').html($h.html());
      $h.html($hidden).append($input)
    }

    $('input:not(.dt-date), select', col.header()).on('keyup change clear', function() {
      if ( col.search() !== this.value ) {
        col.search( this.value ).draw();
      }
    });

    $('input.dt-date', col.header()).on('keyup change clear', function() {
      if ( col._fromDate !== this.value ) {
        col._fromDate = this.value;
        col.draw();
      }
    });

    // Don't trigger sort when clicking inside a search field
    $('input, select', col.header()).on('click', function(e) { e.stopPropagation() });
  });

  $.fn.dataTableExt.afnFiltering.push(
    function(meta, data, index) {
      var col = dt.column(dateFilters[0]);
      var attr = col.dataSrc();

      var input = $('input.dt-date', col.header());
      if (input.length === 0)
        return true;

      var values = input.val().split(':');
      var fromDateValue = new Date(values[0]).getTime();
      var toDateValue = values.length === 2 ? new Date(values[1]).getTime() : null;

      // For caching
      if (typeof data['_'+attr] == 'undefined') {
        data['_'+attr] = new Date(data[dateFilters[0]]).getTime();
      }

      if (fromDateValue && !isNaN(fromDateValue)) {
        if (data['_'+attr] < fromDateValue) {
          return false;
        }
      }
      if (toDateValue && !isNaN(toDateValue)) {
        if (data['_'+attr] > toDateValue) {
          return false;
        }
      }
      return true;
    }
  );
}

function initDataTableRowClick(dt, hasSelect) {
  dt.on('click', 'tbody td:nth-child(n+'+(hasSelect ? 3 : 2)+')', function(evt) {
    // Stop propagation of up-coming click, not to trigger responsive row event
    $('a[data-dt-row-link]', this.parentNode).on('click', function(e) { e.stopPropagation(); });

    // Trigger link click
    if (evt.metaKey) {
      window.open($('a[data-dt-row-link]', this.parentNode)[0].href, '_blank');
    } else {
      $('a[data-dt-row-link]', this.parentNode)[0].click();
    }
  });
}

function idColumnRendererFor(baseUrl) {
  return function(data, type, row) {
    const href = [baseUrl, row.id].join('/');
    return '<div class="hidden-title"><a href="'+href+'" data-dt-row-link>'+row.code+'</a></div>';
  };
}

function formatCurrency(data) {
  var val = parseFloat(data).toFixed(2).toString();

  return $('<div style="text-align: right;"></div>')
    .text(val.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"))
    .prop('outerHTML');
}

var dtThumbRenderer = {
  "display": function(data) {
    return data ? '<img data-src="'+data+'" class="js_dt_img"/>' : null;
  }
};

var dtDateRenderer = {
  '_': function(data) { return new Date(data); },
  'display': function(data) { return data; }
};

function dtOnDrawSetImgSrc() {
  $('.js_dt_img').each(function(i, img) {
    var $img = $(img);
    $img.attr('src', $img.data('src'));
  });
}

function dtAddDateRangeSearch(col) {
  var $from = $('.dt-date .from', col.header());
  var $to = $('.dt-date .to', col.header());

  function isNoDate(d) {
    return !(d instanceof Date && !isNaN(d));
  }

  $.fn.dataTable.ext.search.push(
    function(settings, data, dataIndex) {
      var min = new Date($from.val());
      var max = new Date($to.val());

      var date = new Date(data[col.index()]);

      return (
        (isNoDate(min) && isNoDate(max)) ||
        (isNoDate(min) && date <= max ) ||
        (min <= date   && isNoDate(max) ) ||
        (min <= date   && date <= max )
      );
    }
  );
}

function dtHeaderSearchSelect(col, options) {
  var title = col.header().html();

  var $select = $('<select></select>');
  $select.append('<option></option>').
    attr('value', title).
    html(title);

  options.map(function (option) {
    $select.append('<option></option>').
    attr('value', option).
    html(option);
  });
}
