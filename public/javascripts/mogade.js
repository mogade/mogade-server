$(document).ready(function()
{
  $('input, .button, code').addClass('r');
  $('label.tip').tip();
  $('input.numeric').numeric();
  $('.menu a[href^="' + top.location.pathname + '"]').addClass('active').prepend(':');
});

function do_delete(url, data)
{
  var $form = $('<form>', {method: 'POST', action: url}).hide().appendTo($('body'));
  $form.append($('<input>', {type: 'hidden', name: '_method', value: 'delete'}));
  if (data == null)
  {
    $form.append($('<input>', {type: 'hidden', name: 'authenticity_token', value: AUTH_TOKEN}));
  }
  else
  {
    for(var i = 0; i < data.length; ++i) 
    { 
      var d = data[i];
      $form.append($('<input>', {type: 'hidden', name: d.name, value: d.value})); 
    }
  }
  $form.submit();
  $form.remove();
  return false;
}