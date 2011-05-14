(function($) 
{
  $.fn.tip = function(options)
  {
    return this.each(function()
    {
      if (this.tip) { return; }
      var $label = $(this);
      var $input = $('#' + $label.attr('for'));
      var self = 
      {
        initialize: function()
        {
          $label.hide();
          $input.focus(self.hasFocus).blur(self.lostFocus);
        },
        hasFocus: function()
        {
          $label.show();
        },
        lostFocus: function()
        {
          $label.hide();
        }
      };
      this.tip = self;
      self.initialize();
    });
  };
})(jQuery);