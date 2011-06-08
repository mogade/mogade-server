(function($) 
{
  var defaults = {data: {}, total: 0, perPage: 10, dataUrl: null, loaded: null};
  $.fn.pagedList = function(opts) 
  {        
    var options = $.extend({}, defaults, opts);
    return this.each(function() 
    {
      if (this.pagedList) { return false; }
      var $table = $(this);
      var $tbody = $(this).children('tbody');
      var $pager = $('#' + this.id + '_pager');
      var self =
      {   
        initialize: function()
        {
          self.initializePager();
          $pager.children('a:first').click();
        },
        initializePager: function()
        {
          var totalPages = Math.ceil(options.total/options.perPage);
          if (totalPages < 2) { self.loadPage(1); return; }
          for(var i = 0; i < totalPages; ++i)
          {
            var page = i+1;
            $pager.append('<a href="#' + page + '" class="r">' + page + "</a>");
          }
          $pager.children('a').click(self.pageClicked);
          var errorText = totalPages == 1 ? ' error' :  ' errors';
          $pager.append('<span class="total">' + options.total + errorText + '</span>');
        },
        pageClicked: function()
        {
          var $a = $(this);
          $a.siblings().removeClass('active');
          $a.addClass('active');
          self.loadPage($a.text());
          return false;
        },
        loadPage: function(page)
        {
          options.data['page'] = page;
          $.get(opts.dataUrl, options.data, self.gotData, 'html');
        },
        gotData: function(r)
        {
          if (genericResponseHandler(r)) { return; }
          $tbody.html(r);
          if (opts.loaded) { options.loaded($tbody); }
        }
      };
      this.pagedList = self;
      self.initialize();      
    });
  };
})(jQuery);