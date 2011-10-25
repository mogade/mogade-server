$.message = 
{
  $active: null,
  timerId: null,
  show: function(contents, id, temp) {
    $.message.hide();
    var $message = $('#' + id).length > 0 ? $('#' + id) : $('<div id="' + id + '">');
    $message.html(contents);
    $.message.$active = $message;
    $message.stop();
    
    var $container = $('#messages').html($message)
    if (temp) { $container.addClass('temp'); } 
    else { $message.removeClass('temp'); }
    
    return $message;
  },
  info: function(contents, timer) {
    var $message = $.message.show(contents, 'info', timer ? true : false);
    if (timer) { $.message.timerId = setTimeout($.message.hide, timer); }
    return $message
  },
  error: function(contents, timer) {
    var $message = $.message.show(contents, 'error', timer ? true : false);
    if (timer) { $.message.timerId = setTimeout($.message.hide, timer); }
    return $message
  },
  hide: function() {
    if ($.message.timerId != null) { clearTimeout($.message.timerId); }
    var $message = $.message.$active;
    if ($message == null) { return; }
    var $old = $message;
    $.message.active = null;
    $message.slideUp('fast', function() {
      $old.remove();
    });
  }
};