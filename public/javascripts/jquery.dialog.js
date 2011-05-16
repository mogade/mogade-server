(function($) {
  var defaults = {delay: 4000, zIndex: 100, width: 600, height: 400, autoShow: false, title: null};
  $.fn.dialog = function(command, options) 
  {
    if (command == 'show')
    {
       return this.each(function() 
       { 
          if (options.title) { this.dialog.setTitle(options.title);}
          this.dialog.show(); 
          this.dialog.heightAdjust();
       });
    }
    
    if (command == 'close')
    {
       return this.each(function() 
       { 
          this.dialog.close(); 
       });
    }
  
    var opts = $.extend({}, defaults, command); 
    return this.each(function() 
    {
      if (this.dialog) { return false; }
      var $content = $(this);
      var $this = $('<div>').append(this)
      var $overlay = null;
      var self =
      {
        initialize: function() 
        {
          $content.css('padding', '0px 10px');
          $this.appendTo($('body')).hide().addClass('dialog r').css({ zIndex: opts.zIndex, width: opts.width, height: opts.height });
          $header = $('<h1>').html('<span></span><a></a>');
          $this.prepend($header);
          $overlay = $('<div>').addClass('dialogOverlay').css({ zIndex: opts.zIndex - 1, opacity: 0.5 }).appendTo('body');
          $this.css({ position: 'absolute' });
          self.setTitle(opts.title);
          if (opts.autoShow) { self.show(); }
          self.bindEvents();
        },
        show: function() 
        {
          self.position();
          $overlay.show();
          $this.show();
        },
        close: function() 
        {
          $overlay.hide();
          $this.hide();
        },
        getDimensions: function() 
        {
          var el = $(window);
          var h = $.browser.opera && $.browser.version > '9.5' && $.fn.jquery <= '1.2.6' ? document.documentElement['clientHeight'] : el.height();
          return [h, el.width()];
        },
        position: function() 
        {
          var dimensions = self.getDimensions();
          $overlay.height(dimensions[0]).width(dimensions[1]);
          $this.center();
        },
        bindEvents: function() 
        {
          $(window).bind('resize', self.position);
          $('h1 a', $this).bind('click', self.close);
          $(document).bind('keydown', function(e)  { if (e.keyCode == 27) { self.close(); } });
        },
        setTitle: function(title) 
        {
          if (title) { $('h1 span', $this).text(title); }
        },
        setBody: function(body) 
        {
          if (body) { $content.html(body); }
        },
        heightAdjust: function() 
        {
          $this.height($content.height() + $('.dialogHeader', $this).height() + 30);
        },
      };
      this.dialog = self;
      self.initialize();
    });
  };
})(jQuery);

  
jQuery.fn.center = function() 
{
    this.css("position", "absolute");
    this.css("top", '200px');
    this.css("left", ($(window).width() - this.width()) / 2 + $(window).scrollLeft() + "px");
    return this;
};

(function($)
{
  $.fn.confirm = function(title, message, onYes)
  {
    return this.each(function()
    {
      var $element = $(this);
      $element.click(function()
      {                
        $.showConfirm(title, message, onYes, $(this));
        return false;
      });
    });
  };
})(jQuery);

jQuery.showConfirm = function(title, message, onYes, $element)
{
  var $yes = $('<input>').attr({type: 'button', value: 'yes'}).addClass('button r').click(function() { onYes($element); $dialog.dialog('close');});
  var $no = $('<input>').attr({type: 'button', value: 'no'}).addClass('button r').click(function() { $dialog.dialog('close');});
  var $buttons = $('<div>').addClass('buttons').append($yes).append($no);
  var $content = $('<p>').text(message).append($buttons);                
  var $dialog = $('<div>').append($content).dialog({autoShow:true, title: title, height:145, width:475, zIndex:200});  
};