(function($){
   $.fn.purdySelect = function(options)
   {
      var defaults = {selected: null, startWith: null, minimumDate: null, maximumDate: null};
      return this.each(function() 
      {
         if (this.purdySelect) { return false; }
         var $select = $(this);
         var $container, $current, $ul = null;
         var itemLookup = {};
         var self = 
         {
            initialize: function() 
            {
               $ul = self.buildOptions().delegate('li', 'click', self.select);
               $current = $('<div>');
               $container = $('<div>', {'class': 'purdySelect'}).width($select.width() + 120).append($current).append($ul).click(self.toggle);
               itemLookup[$select.val()].click();
               $select.before($container).hide();
               $(document).keydown(function(e)
               { 
                  if (e.keyCode == 27) { self.close(); } 
               }).click(function(e)
               {
                  if (self.isShowing() && $(e.target).closest('div.purdySelect')[0] != $container[0]) { self.close(); }
               });
               
            },
            buildOptions: function()
            {
               var $ul = $('<ul>');
               $select.children().each(function(i, option)
               {
                  var $li = $('<li>').data('value', option.value).html(option.innerHTML);
                  itemLookup[option.value] = $li;
                  $ul.append($li);
               });
               return $ul;
            },
            toggle: function()
            {
               if (self.isShowing()) { self.close(); }
               else {self.show(); }
            },
            show: function()
            {
               $container.children('div').addClass('opened');
               $ul.show();
            },
            close: function()
            {
               $container.children('div').removeClass('opened');
               $ul.hide();
            },
            isShowing: function()
            {
               return $ul.is(':visible');
            },
            select: function(e)
            {
               var $li = $(this);
               $li.siblings().removeClass('selected').end().addClass('selected');
               self.setSelection($li.data('value'), $li.html());
               e.stopPropagation();
            },
            setSelection: function(value, html)
            {
               $select.val(value).change();
               $current.html(html);
               self.close();
            }
         };
         this.purdySelect = self;
         self.initialize();
      });
   }
})(jQuery);