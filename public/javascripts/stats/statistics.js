$(document).ready(function()
{
  var $graph = $('#graph');
  var $raw = $('#raw tbody');
  var now = new Date();
  var lastWeek = new Date();
  lastWeek.setDate(now.getDate() - 7);
  $('#date').dateRange(
  {
    startWith: new Array(now, lastWeek),
    minimumDate: new Date(2011, 0, 1),
    maximumDate: now,
    selected: datesSelected
  });
  
  var graphOptions =
  {
    xaxis: { mode: 'time', timeformat: '%d %b', minTickSize: [1, 'day']  , monthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'] },
    legend: {backgroundOpacity: 0, container: $('#legend'), noColumns: 3},
    grid: {hoverable: true}
  };
  
  function datesSelected(range)
  {
    var from = Date.UTC(range[0].getFullYear(), range[0].getMonth(), range[0].getDate());
    var to = Date.UTC(range[1].getFullYear(), range[1].getMonth(), range[1].getDate());
    $.post('/manage/stats/data', {id: $('#id').val(), from: Math.round(from/1000), to: Math.round(to/1000), authenticity_token: AUTH_TOKEN}, responseReceived, 'json');
  };
  function responseReceived(r)
  {
    var series = [];
    var from = new Date(r.from * 1000);
    for(var i = 0; i < 3; ++i)
    {
      series[i] = [];
      for(var j = 0; j < r.days; ++j)
      {
       var value = r.data[i][j] == null ? 0 : r.data[i][j];
       series[i].push([new Date(from.getTime() + (j * 86400000)), value]);
      }
    }
    $.plot($graph, [{label: 'game loads', lines: {show: true}, points: {show: true}, data: series[0]}, {label: 'unique users', bars: {show: true, barWidth:15000000, align: 'left'}, data: series[1]}, {label: 'new users', bars: {show: true, barWidth:15000000, align: 'center'}, data: series[2]}], graphOptions);

    $raw.empty();
    var indexes = new Array();
    for(var i = 0; i < r.days; ++i)
    {
      var $row = $('<tr>').appendTo($raw);
      var date = new Date(from.getTime() + (i * 86400000));
      $('<td>').text(new Date(date).ymd()).appendTo($row);
      for(var j = 0; j < 3; ++j)
      {
        var value = r.data[j][i] == null ? 0 : r.data[j][i];
        $('<td>').text(value).appendTo($row);
      }
    }
  }
  var $tip = $('<div id="reportTip">').addClass('r').appendTo($('body')).data('meta', {});
  $graph.bind('plothover', function (event, pos, item) 
  {
    if (!item) {return;}
    var meta = {s: item.seriesIndex, d: item.dataIndex};
    var existing = $tip.data('meta');
    if (existing.s == meta.s && existing.d == meta.d) { return; }
    $tip.text(item.datapoint[1]).show().css({top: item.pageY-20, left: item.pageX+10}).data('meta', meta);
  });
  
  
  //Download stuff
  $('#downloadMenu a').click(function() { 
    var frame = $('#downloadFrame')[0];
    frame.src = '/manage/stats/data?id=' + $('#id').val() + '&year=' + $(this).attr('data-year');
    return false;
  });
});
  