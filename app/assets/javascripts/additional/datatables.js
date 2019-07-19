// A Function to create and attach a dropdown button
// to show and hide columns from the data table.
//
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

function idColumnRendererFor(baseUrl) {
  return function(data, type, row) {
    const href = [baseUrl, row.id].join('/');
    return '<a href="'+href+'"><i class="fa fa-arrow-circle-right"></i></a>';
  };
}

function formatCurrency(data) {
  var val = parseFloat(data).toFixed(2).toString();

  return $('<div style="text-align: right;"></div>')
    .text(val.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"))
    .prop('outerHTML');
}
