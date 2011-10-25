function genericResponseHandler(json) {
  if (json == null) { return false; }
  if (typeof(json) == 'string') {
    try { json = $.parseJSON(json); }
    catch(e){ return false; }
  }
  
  if (json.redirect) { top.location = json.redirect; return true; }
  if (json.error) { $.message.error(json.error); return true; }
  
  if (json.invalid) {
    for(var name in json.invalid) {
      var $field = $('[name="' + name + '"]').addClass('error');
      var $label = $field.siblings('label.error');
      if ($label.length == 0)  {
        $label = $('<label>').addClass('error').appendTo($field.parent());
      }
      $label.text(json.invalid[name]);
    }
    return true;
  }
  return false;
};