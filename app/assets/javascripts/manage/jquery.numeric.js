(function($) {
  $.fn.numeric = function(command) {
    if (command == 'unload') {
      return this.each(function() { if (this.numeric) { this.numeric.unload(); } });
    }
    return this.each(function()  {
      if (this.numeric) { return false; }
      var input = this;
      var $input = $(input);
      var oldValue = input.value;
      var maxlength = $input.attr('maxlength');
      var self = {
        initialize: function() {
          $input.keypress(self.validate).keyup(function(){oldValue = $input.val();})
          if (!maxlength || maxlength > 300) { maxlength = 15;}
        },
        validate: function(e) {
          if (e.which == 13) {return true;}
          var caret = $input.caret();
          var value = input.value;
          value = value.substring(0, caret.start) + String.fromCharCode(e.which) + value.substring(caret.end);
          if (value == oldValue) { return true; }
          if (value == '') { return true; }
          if (value.length <= maxlength && value.match(/^-?\d*$/)){ return true; }
          input.value = oldValue;
          return false;
        },
        reset: function() {
          oldValue = '';
        },
        unload: function() {
          $input.unbind();
          this.numeric = null;
        }
      };
      this.numeric = self;
      self.initialize();
    });
  }
})(jQuery);