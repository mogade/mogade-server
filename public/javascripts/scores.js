$(document).ready(function()
{
  var $operators = $('#operator').clone();
  console.log($('#filter'));
  $('#filter').change(function()
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
});