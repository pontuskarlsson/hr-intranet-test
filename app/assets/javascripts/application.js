// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require date.format
//= require Chart.bundle
//= require chartkick
//= require_tree ./additional


$(function(){ $(document).foundation(); });

$(function(){
  $(document.body).delegate('.js_click_loader', 'click', function(evt){
    var $t = $(this);
    if ($t.is(':disabled')) {
      evt.preventDefault();
    } else {
      setTimeout(function(){
        $t.attr('disabled', 'disabled');
        if ($t.is('a')) {
          $t.html(['<img src="/assets/ajax-loader.gif"/>', $t.html()].join(''));
        }
      }, 1);
    }
  });

  $(document.body).on('open.zf.reveal', function(evt) {
    if ($(evt.target).hasClass('js-image-reveal')) {
      var $img = $('.dragonfly-image-tag', evt.target);
      $img.attr('src', $img.data('src'));
    }
  });

  $(document.body).on('error', 'img.dragonfly-thumb-tag:not(.dragonfly-reloaded)', function(evt) {
    var $img = $(evt.target);
    var src = $img.attr('src');

    // Set src to 1px gif temporary
    $img.attr('src', 'data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D');
    // Attempty to load the src again
    setTimeout(function() {
      $img.attr('src', src);
    }, 1000);

    $img.addClass('dragonfly-reloaded');
  });

  $(document.body).on('change.zf.tabs', function(evt, $title, $pane) {
    var $imgs = $('.dragonfly-thumb-tag[data-src]', $pane);
    $imgs.each(function(i, el) {
      var $img = $(el);
      $img.attr('src', $img.data('src'));
    });
  });

  $(document.body).on('change', '.js_append_selected_files', function(evt) {
    var $t = $(this);

    var $file_cont = $t.siblings('.js_file_cont');

    if ($file_cont.length === 0) {
      $file_cont = $('<div class="js_file_cont"><h5>Selected File(s)</h5></div>').appendTo($t.parent());
    }

    $file_cont.html();
    var files = $t[0].files;

    for (var i = 0; i < files.length; i++) {
      $('<div></div>').html(files[i].name).appendTo($file_cont);
    }
    console.log('test')
  })
});
