(function($) 
{
  var defaults = {lids: null, baseUrl: 'http://mogade.com/api/gamma/scores/'}
  $.fn.topScores = function(opts) 
  {
    var options = $.extend({}, defaults, opts); 
    return this.each(function() 
    {
      if (this.topScores) { return false; }
      var $container = $(this);
      var data = {lid: options.lids[0][0]};
      var self =
      {
        initialize: function() 
        {
          self.buildLeaderboardChoice($container);
          $container.show();
          self.getTopScores();
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
        leaderboardChanged: function()
        {
          data['lid'] = $(this).val();
          self.getTopScores();
          return false;
        },
        getTopScores: function()
        {
          $.ajax({
            url: options.baseUrl,
            data: data,
            type: 'GET',
            dataType: 'jsonp',
            success: self.gotTopScores,
          });
        },
        gotTopScores: function(d)
        {
          $container.children().remove('div.scope');
          $container.append(self.buildFor(d[4], 'yesterday'));
          $container.append(self.buildFor(d[1], 'today'));
          $container.append(self.buildFor(d[2], 'this week'));
          $container.append(self.buildFor(d[3], 'overall'));
          $container.children('div.scope:odd').css('margin-right', 0);
        },
        buildFor: function(data, name)
        {
          if (data.length == 0) {return;}
          var $div = $('<div class="scope">');
          $div.append('<h3>' + name + '</h3>');
          var $ul = $('<ul>');
          for(var i = 0; i < data.length; ++i)
          {
            var points = '<span>' + data[i]['points'] + '</span>';
            var name = '<li>' + data[i]['username'] + points + '</li>';
            $ul.append(name);
          }
          $ul.children(':last').css('border-bottom', 'none');
          return $div.append($ul);
        }
      };
      this.topScores = self;
      self.initialize();
    });
  };
})(jQuery);