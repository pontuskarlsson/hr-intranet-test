window.Addable = { partials: {} };

$(document).ready(function() {

  $(document).on('click', '.form-addable .form-addable-controls .form-ctrl-add', function(evt) {
    var $target = $(evt.target);
    var $container = $target.closest('.form-addable');

    var partial = Addable.partials[$container.data('form-container')];

    if (!partial)
      return;

    var template = partial.template;

    var index = partial.template_index || '__index__';

    for (var k in partial.attributes) {
      template = template.replace(new RegExp(k, 'g'), partial.attributes[k]);
    }

    var $record = $('<div class="form-addable-record form-init">'+template+'</div>').appendTo($container);

    if (window.ReactRailsUJS) { ReactRailsUJS.mountComponents($record[0]); }
    
    $record.show();
    $record.removeClass('out').addClass('active');

    partial.attributes[index]++;
  });

  $(document).on('click', '.form-addable .form-addable-record .form-addable-remove', function(evt) {
    var $target = $(evt.target);
    var $record = $target.closest('.form-addable-record');
    var $field = $('input[type=hidden]', $target.closest('.form-addable-remove'));

    $record.removeClass('active').addClass('out');

    setTimeout(function() {
      if ($field.length > 0) {
        $field.attr('value', '1');
        $record.hide();
      } else {
        $record.remove();
      }
    }, 300); //Same time as animation

  });

  $(document).on('mouseover', '.form-addable .form-addable-record .form-addable-remove', function(evt) {
    var $target = $(evt.target);
    var $record = $target.closest('.form-addable-record');

    $record.addClass('highlight');
  });

  $(document).on('mouseout', '.form-addable .form-addable-record .form-addable-remove', function(evt) {
    var $target = $(evt.target);
    var $record = $target.closest('.form-addable-record');

    $record.removeClass('highlight');
  });

  $(document).on('mouseover', '.form-addable .form-addable-controls .form-ctrl-add', function(evt) {
    var $target = $(evt.target);
    var $controls = $target.closest('.form-addable-controls');

    $controls.addClass('highlight');
  });

  $(document).on('mouseout', '.form-addable .form-addable-controls .form-ctrl-add', function(evt) {
    var $target = $(evt.target);
    var $controls = $target.closest('.form-addable-controls');

    $controls.removeClass('highlight');
  });

});
