$(document).ready(function()
{
  var $confirm = $('#confirm').hide();
  var $confirmNone = $('#confirmNone').hide();

  var $operators = $('#operator').clone();
  $('#field').change(function()
  {
    var $operator = $('#operator');
    var $value = $('#value').val('');
    if ($(this).val() == '1')
    {
      $operator.children('[value!="3"]').remove();
      $value.numeric('unload');
    }
    else
    {
      $operator.after($operators.clone()).remove();
      $value.numeric();
    }
  }).change();
  
  var $form = $('#form').submit(function()
  {
    $('#score_submit').val('Working...');
    $.get('/manage/scores/count', $form.serialize(), gotCount, 'json');
    disableForm(true);
    return false;
  });
  
  
  function disableForm(trueOrFalse)
  {
    $form.find('select, input').attr('disabled', trueOrFalse);
  }
  
  function gotCount(r)
  {
    $('#score_submit').val('find');
    if (r.count > 0)
    {
      $confirm.find('span').text(r.count);
      $confirmNone.hide();
      $confirm.show();
    }
    else
    {
      disableForm(false);
      $confirmNone.show();
      $confirm.hide();
    }
    if (r.count > 1) { $('#leet').show(); }
    else { $('#leet').hide(); }
  };
  
  $('#no').click(function(){ $confirm.hide(); disableForm(false); });
  $('#yes').click(function()
  {
    disableForm(false);
    do_delete('/manage/scores/' + $('#id').val(), $form.serializeArray());
    disableForm(true);
  });
});