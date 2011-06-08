$(document).ready(function()
{
  $('input, .button, code').addClass('r');
  $('label.tip').tip();
  $('input.numeric').numeric();
  $('.menu a[href="' + top.location.pathname + top.location.search + '"]').addClass('active').prepend(':');
});

function do_delete(url, data, callback)
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
  if (callback)
  {
    $.post($form.attr('action'), $form.serialize(), callback, 'json');
  }
  else
  {
    $form.submit();
  }
  $form.remove();
  return false;
}