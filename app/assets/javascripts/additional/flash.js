$(function() {
  var $flash = $('.flash_close');
  if ($flash.length > 0) {
    $('.flash_close').on('click', function() { $(this).parents('.flash').addClass('hidden'); })
    setTimeout(function() { $('.flash').addClass('hidden'); }, 3000);
  }
});
