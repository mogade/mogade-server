(function($) 
{
   var defaults = {lid: null, scope: 0, records: 10, page: 1, baseUrl: 'http://mogade.com/api/gamma/scores/'}
   var monthnames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
   $.fn.leaderboard = function(opts) 
   {
      var options = $.extend({}, defaults, opts); 
      return this.each(function() 
      {
         if (this.leaderboard) { return false; }
         var $container = $(this);
         var $table, $tbody, $error, $tabContainer, $pager = null;
         var data = {lid: options.lid, scope: options.scope, page: options.page}
         var previousPage = 0;
         var self =
         {
            initialize: function() 
            {
               $tabContainer = $container.children('div.tabs').delegate('div', 'click', self.scopeChange);
               $table = $container.children('table');
               $pager = $container.children('div.pager').delegate('div', 'click', self.pageChanged);
               $error = $('<div>').appendTo($container);
               $tbody = $table.find('tbody');
               $tabContainer.children().eq(options.scope).click();
            },
            scopeChange: function()
            {
              var $tab = $(this);
              var $tabs = $tabContainer.children();
              var index = $tabs.index($tab);
              previousPage = 0;
              data['scope'] = index + 1;
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
               $table.find('th:last').text(dateTimeName);
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
            buildUrl: function()
            {
               return options.baseUrl + options.lid + '/' + page + '/' + options.scope + '/' + options.records + '/';
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
              prev ? $pager.find('.prev').show() : $pager.find('.prev').hide();
              next ? $pager.find('.next').show() : $pager.find('.next').hide();
              $pager.show();
            }
         };
         this.leaderboard = self;
         self.initialize();
      });
   };
})(jQuery);