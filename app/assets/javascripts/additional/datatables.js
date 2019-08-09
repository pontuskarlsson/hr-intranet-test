// A Function to create and attach a dropdown button
// to show and hide columns from the data table.
//
function initDataTable(dt) {
  initDataTableMenu(dt);
  initDataTableHeaders(dt);
  initDataTableRowClick(dt)
}

function initDataTableMenu(dt) {
  var tmplMenu = '<ul class="dropdown menu" data-dropdown-menu><li><a href="#">Columns</a><ul class="menu"></ul></li></ul>';
  var tmplItem = '<li><a href="#"><i class="fa"></i></a></li>';

  var classVisible = 'fa-check-square-o';
  var classHidden = 'fa-square-o';

  var $menu = $(tmplMenu);

  dt.columns().every(function(colIndex) {
    if (colIndex === 0) return;

    var col = dt.column(colIndex);

    var $item = $(tmplItem);
    $('> a > i.fa', $item).addClass(col.visible() ? classVisible : classHidden);
    $('> a', $item).append($(col.header()).html()).data('col-index', colIndex);

    $('.menu', $menu).append($item);
  });

  $(dt.table().container()).prepend($menu);

  new Foundation.DropdownMenu($menu, { 'closeOnClickInside': false });

  $menu.on('click', '.menu > li > a', function() {
    var col = dt.column($(this).data('col-index'));

    col.visible(!col.visible());

    $('i.fa', this).toggleClass('fa-check-square-o');
    $('i.fa', this).toggleClass('fa-square-o');

    dt.columns.adjust();
  });
}

function initDataTableHeaders(dt) {
  dt.columns().every(function() {
    var col = this;
    var $h = $(col.header());

    if ($h.data('dt-search-select')) {
      var $select = $('<select></select>').append($('<option></option>').attr('value', "").html($h.html()));

      $h.data('dt-search-select').split(',').map(function(v) {
        $select.append($('<option></option>').attr('value', v).html(v));
      });
      $h.html($select)

    } else if ($h.data('dt-search-input')) {
      var $input = $('<input type="text" />').attr('placeholder', $h.html());
      $h.html($input)
    }

    $('input:not(.dt-date), select', col.header()).on('keyup change clear', function() {
      if ( col.search() !== this.value ) {
        col.search( this.value ).draw();
      }
    });

    // Don't trigger sort when clicking inside a search field
    $('input, select', col.header()).on('click', function(e) { e.stopPropagation() });
  });
}

function initDataTableRowClick(dt) {
  dt.on('click', 'tbody td:not(:first-child)', function() {
    // Stop propagation of up-coming click, not to trigger responsive row event
    $('a[data-dt-row-link]', this.parentNode).on('click', function(e) { e.stopPropagation(); });

    // Trigger link click
    $('a[data-dt-row-link]', this.parentNode)[0].click();
  });
}

function idColumnRendererFor(baseUrl) {
  return function(data, type, row) {
    const href = [baseUrl, row.id].join('/');
    return '<a href="'+href+'" data-dt-row-link></a>';
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
