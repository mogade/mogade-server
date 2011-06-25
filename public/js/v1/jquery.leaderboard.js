(function($) 
{
  var defaults = {lids: null, scope: 0, records: 10, page: 1, baseUrl: 'http://api.mogade.com/api/gamma/scores', nextText: 'next', previousText: 'prev', data: null}
  var monthnames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  $.fn.leaderboard = function(opts) 
  {
    var options = $.extend({}, defaults, opts); 
    return this.each(function() 
    {
      if (this.leaderboard) { return false; }
      var $container = $(this);
      var $table, $tbody, $error, $tabContainer, $pager, $lid = null;
      var data = {lid: options.lids[0][0], scope: options.scope, page: options.page};
      var previousPage = 0;
      var self =
      {
        initialize: function() 
        {
          self.buildLeaderboardChoice($container);
          $tabContainer = self.buildScopeTabs($container);
          $table = self.buildTable($container);
          $pager = self.buildPager($container);
          
          $table = $container.children('table');
          $error = $('<div>').appendTo($container);
          $tbody = $table.find('tbody');
          $tabContainer.children().eq(options.scope).click();
          $container.show();
        },
        buildLeaderboardChoice: function($container)
        {
          if (options.lids.length == 1)
          {
            return $('<div class="leaderboard_name">').text(options.lids[0][1]).appendTo($container);
          }     
          var $select = $('<select class="leaderboard_name">').appendTo($container)
          for(var i = 0; i < options.lids.length; ++i)
          {
            var lid = options.lids[i];
            $select.append($('<option>').text(lid[1]).val(lid[0]))
          }
          if ($select.purdySelect) { $select.purdySelect(); }
          return $select.change(self.leaderboardChanged);
        },
        buildScopeTabs: function($container)
        {
          var $tabs = $('<div class="tabs">');
          $tabs.append($('<div>').data('scope', 1).text('today'));
          $tabs.append($('<div>').data('scope', 2).text('this week'));
          $tabs.append($('<div>').data('scope', 3).text('overall'));
          $tabs.append($('<div>').data('scope', 4).text('yesterday'));
          $tabs.delegate('div', 'click', self.scopeChanged);
          return $tabs.appendTo($container);
        },
        buildTable: function($container)
        {
          var $table = $('<table>');
          var $thead = $('<thead>').appendTo($table);
          var $tr = $('<tr>').appendTo($thead)
            .append($('<th class="rank">').text('rank'))
            .append($('<th class="name">').text('name'))
            .append($('<th class="score">').text('score'))
            .append($('<th class="date">').text('date'));
            
          if (options.data)
          {
            $tr.append($('<th class="data">').text(options.data.name))
          }
          return $table.append($('<tbody>')).appendTo($container);
        },
        buildPager: function($container)
        {
          var $pager = $('<div class="pager">').css('display', 'none');
          $('<div class="prev">').text(options.previousText).appendTo($pager);
          $('<div class="next">').text(options.nextText).appendTo($pager);
          return $pager.delegate('div', 'click', self.pageChanged).appendTo($container);
        },
        scopeChanged: function()
        {
          var $tab = $(this);
          previousPage = 0;
          data['scope'] = $tab.data('scope');
          data['page'] = 1;
          self.getLeaderboard();
          return false;
        },
        pageChanged: function()
        {
          var page = data['page'];
          var previousPage = page;
          if ($(this).is('.next')) { ++page; }
          else { --page; }

          data['page'] = page;
          self.getLeaderboard();
          return false;
        },
        leaderboardChanged: function()
        {
          data['page'] = 1
          data['lid'] = $(this).val();
          self.getLeaderboard();
          return false;
        },
        getLeaderboard: function()
        {
          $.ajax({
            url: options.baseUrl,
            data: data,
            type: 'GET',
            dataType: 'jsonp',
            success: self.gotLeaderboard,
          });
        },
        gotLeaderboard: function(d)
        {  
          var $tabs = $tabContainer.children();
          $tabs.removeClass('active');
          $tabs.eq(data['scope']-1).addClass('active');
          
          if (d.scores.length == 0) { return self.noData(); }
          self.setPagerVisibility(d.page > 1, d.scores.length == options.records);
          
          var dateTimeName = self.isDailyScope() ? 'time' : 'date';
          $table.find('th.date').text(dateTimeName);
          $table.show();
          $error.hide();
          var page = d.page;
          var rows = [];
          for(var i = 0; i < d.scores.length; ++i)
          {
            var score = d.scores[i];
            var $row = $('<tr>');
            if (i % 2 == 1) { $row.addClass('odd'); }
            $row.append(self.createCell((page - 1) * options.records + i + 1));
            $row.append(self.createCell(score.username));
            $row.append(self.createCell(score.points));
            $row.append(self.createCell(self.formatDate(new Date(score.dated))));
            if (options.data)
            {
              $row.append(self.createCell(options.data.handler(score.data)));
            }
            rows.push($row);
          }
          if (previousPage == 0) {$tbody.empty(); for(var i = 0; i < rows.length; ++i) { $tbody.append(rows[i]);} }
          else if (previousPage < page){ self.loadNextRows(rows, 0, $tbody.children().length); }
          else{ self.loadPrevRows(rows, rows.length, $tbody.children().length); }
          previousPage = page;
        },
        loadNextRows: function(rows, index, previous)
        {
          if (index == rows.length) { return; }
          setTimeout(function()
          {
           if (index < previous) { $tbody.children().first().remove(); }
           $tbody.append(rows[index]);
           self.loadNextRows(rows, ++index, previous)
          }, 10)
        },
        loadPrevRows: function(rows, index, previous)
        {
          if (index == -1) { return; }
          setTimeout(function()
          {
           if (index < previous) { $tbody.children().last().remove(); }
           $tbody.prepend(rows[index]);
           self.loadPrevRows(rows, --index, previous)
          }, 10)
        },
        formatDate: function(date)
        {
          var time = date.getHours() + ':' + (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes());
          if (self.isDailyScope())
          {
           return time;
          }
          return monthnames[date.getMonth()] + ' ' + date.getDate() + ', ' + time;
        },
        isDailyScope: function()
        {
          return data.scope == 1 || data.scope == 4;
        },
        createCell: function(text)
        {
          return '<td>' + text + '</td>';
        },
        noData: function()
        {
          $table.hide();
          $tbody.empty();
          self.setPagerVisibility(data['page'] > 1, false);
          $error.text('no scores are available right now').show();
        },
        setPagerVisibility: function(prev, next)
        {
          prev ? $pager.children('div.prev').show() : $pager.children('div.prev').hide();
          next ? $pager.children('div.next').show() : $pager.children('div.next').hide();
          $pager.show();
        }
      };
      this.leaderboard = self;
      self.initialize();
    });
  };
})(jQuery);