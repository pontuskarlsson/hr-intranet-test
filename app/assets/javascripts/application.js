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

$(function(){ $(document).foundation(); });

$(function(){
  $(document.body).delegate('.js_click_loader', 'click', function(evt){
    var $t = $(this);
    if ($t.is(':disabled')) {
      evt.preventDefault();
    } else {
      $t.attr('disabled', 'disabled');
      if ($t.is('a')) {
        $t.html(['<img src="/assets/ajax-loader.gif"/>', $t.html()].join(''));
      }
    }
  });
});
