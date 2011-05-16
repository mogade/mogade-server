$(document).ready(function()
{
  $('input, .button').addClass('r');
  $('label.tip').tip();
  $('input.numeric').numeric();
  $('.menu a[href^="' + top.location.pathname + '"]').addClass('active').prepend(':');
});

function do_delete(url)
{
  var $form = $('<form>', {method: 'POST', action: url}).hide().appendTo($('body'));
  $form.append($('<input>', {type: 'hidden', name: '_method', value: 'delete'}));
  $form.append($('<input>', {type: 'hidden', name: 'authenticity_token', value: AUTH_TOKEN}));
  $form.submit();
  $form.remove();
  return false;
}