$(document).ready(function()
{
  var $scores = $('#scores');
  $('#delete').confirm(null, 'Delete these scores?', 'This scores will be permanently deleted and cannot be recovered. Are you sure?', function()
  { 
    return do_delete($scores.attr('action'), $scores.serializeArray());
  });

  var $form = $('#form').submit(function()
  {
    $('#score_submit').val('working...');
    $.get('/manage/scores/find', $form.serialize(), gotResults, 'json');
    disableForm(true);
    return false;
  });

  function disableForm(trueOrFalse)
  {
    $form.find('select, input').attr('disabled', trueOrFalse);
  }
  
  function gotResults(r)
  {
    var $tbody = $scores.find('tbody').empty();
    $('#score_submit').val('find');
    disableForm(false);
    if (r && r.length > 0)
    {
      for(var i = 0; i < r.length; ++i)
      {
        var score = r[i];
        var $tr = $('<tr>');
        var $check = $('<input>', {type: 'checkbox', name: 'ids[]', value: score['id']});
        $tr.append($('<td>').append($check));
        $tr.append($('<td>').text(score['username']));
        $tr.append($('<td>').text(score['points']));
        $tr.append($('<td>').text(score['data']));
        $tr.appendTo($tbody);
      }
      $scores.find('input[name=id]').val($form.find('select[name=id]').val());
      $scores.find('input[name=scope]').val($form.find('select[name=scope]').val());
      $scores.show();
    }
    else
    {
      $.message.error('No scores found', 3000);
    }
  };
  
  $('#toggleAll').click(function()
  {
    $scores.find('input').attr('checked', this.checked);
  });
});