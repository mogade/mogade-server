$.message = 
{
  $active: null,
  timerId: null,
  show: function(contents, id)
  {
    $.message.hide();
    var $message = $('#' + id).length > 0 ? $('#' + id) : $('<div id="' + id + '">');
    $message.html(contents);
    $.message.$active = $message;
    $message.stop();
    $('#messages').html($message)
    return $message;
  },
  info: function(contents)
  {
    var $message = $.message.show(contents, 'info');
    //$.message.timerId = setTimeout($.message.hide, 5000);
    return $message
  },
  error: function(contents)
  {
    var $message = $.message.show(contents, 'error');
    //$.message.timerId = setTimeout($.message.hide, 5000);
    return $message
  },
  hide: function()
  {
    if ($.message.timerId != null) { clearTimeout($.message.timerId); }
    var $message = $.message.$active;
    if ($message == null) { return; }
    var $old = $message;
    $.message.active = null;
    $message.slideUp('fast', function()
    {
      $old.remove();
    });
  }
};