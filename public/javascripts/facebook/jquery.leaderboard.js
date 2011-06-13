(function($) 
{
   var defaults = {lid: null, scope: 3, records: 10, page: 1, baseUrl: 'http://mogade.com/api/gamma/scores/', headers: ['rank', 'name', 'score', 'date']}
   var monthnames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
   $.fn.mogade = function(opts) 
   {
      var options = $.extend({}, defaults, opts); 
      return this.each(function() 
      {
         if (this.mogade) { return false; }
         var $container = $(this);
         var $table, $tbody, $error, $tabContainer, $pager = null;
         var data = {lid: options.lid, scope: options.scope, page: options.page}
         var page = 1;
         var self =
         {
            initialize: function() 
            {
               $tabContainer = self.buildTabs().appendTo($container).delegate('div', 'click', self.scopeChange);
               $table = self.buildTable().appendTo($container).hide();
               $pager = self.buildPage().appendTo($container).hide().delegate('div', 'click', self.pageChanged);
               $error = $('<div>').appendTo($container);
               $tbody = $table.find('tbody');
               $tabContainer.children().eq(options.scope).click();
            },
            buildTabs: function()
            {
              var scopes = ['today', 'this week', 'overall', 'yesterday'];
              var $container = $('<div>').addClass('tabs');
              for(var i = 0; i < scopes.length; ++i)
              {
                var $tab = $('<div>').attr('scope', i).text(scopes[i]);
                $container.append($tab)
              }
              return $container;
            },
            buildPage: function()
            {
              var $container = $('<div>').addClass('pager');
              $container.append($('<div>').addClass('prev').text('prev'));
              $container.append($('<div>').addClass('next').text('next'));
              return $container;
            },
            buildTable: function()
            {
               var $head = $('<thead>');
               for(var i = 0; i < options.headers.length; ++i)
               {
                  $head.append('<th class="' + options.headers[i] + '">' + options.headers[i] + '</th>');
               }
               return $('<table class="leaderboard">').append($head).append('<tbody>');
            },
            scopeChange: function()
            {
              var $tab = $(this);
              var $tabs = $tabContainer.children();
              var index = $tabs.index($tab);
              data['scope'] = index + 1;
              data['page'] = 1;
              self.getLeaderboard();
            },
            pageChanged: function()
            {
              var page = data['page'];
              if ($(this).is('.next')) { ++page; }
              else { --page; }

              data['page'] = page;
              self.getLeaderboard();
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
               $tbody.empty();
               var page = d.page;
               for(var i = 0; i < d.scores.length; ++i)
               {
                  var score = d.scores[i];
                  var $row = $('<tr>').appendTo($tbody);
                  if (i % 2 == 1) { $row.addClass('odd'); }
                  $row.append(self.createCell((page - 1) * options.records + i + 1));
                  $row.append(self.createCell(score.username));
                  $row.append(self.createCell(score.points));
                  $row.append(self.createCell(self.formatDate(new Date(score.dated))));
               }
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
               self.setPagerVisibility(true, false);
               $error.text('no scores are available right now').show();
            },
            setPagerVisibility: function(prev, next)
            {
              prev ? $pager.find('.prev').show() : $pager.find('.prev').hide();
              next ? $pager.find('.next').show() : $pager.find('.next').hide();
              $pager.show();
            }
         };
         this.mogade = self;
         self.initialize();
      });
   };
})(jQuery);