$(document).ready(function()
{
  $('input, .button').addClass('r');
  $('label.tip').tip();
  $('.menu a[href="' + top.location.pathname + '"]').addClass('active').prepend(':');
})