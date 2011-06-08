(function($) 
{
  var defaults = {types: null, names: null, saveUrl: null, editable: '#editable', postData: null, saved: null};
  $.fn.inlineEdit = function(options) 
  {
    var opts = $.extend({}, defaults, options);
    return this.each(function() 
    {
      if (this.inlineEdit) { return false; }
      var $editable = $(opts.editable);
      var $button = $(this);
      var state = 'normal'
      var self =
      {   
        initialize: function()
        {
          $button.click(self.clicked);
          $(document).keydown(self.keydown);
        },
        clicked: function()
        {
          if (state == 'normal') { self.startEditMode(); }
          else { self.save() }
          return false;
        },
        keydown: function(e)
        {
          if (e.which == 27) { self.cancelEdit(false); }
        },
        cancelEdit: function(persist)
        {
          for (var i = 0; i < opts.types.length; ++i)
          {
            var type = opts.types[i]
            var $control = $editable.find('[data-edit-id=' + i + ']');
            var original = persist ? self.controlValue(type, $control.find('input')) : $control.data('original');      
            $control.empty();
            $control.text(original);
          }
          state = 'normal',
          $button.text('edit');
          return true;
        },
        controlValue: function(type, $input)
        {
          return $input.val();
        },
        startEditMode: function()
        {
          state = 'edit';
          $button.text('save');
          for(var i = 0; i < opts.types.length; ++i)
          {
            var type = opts.types[i];
            var name = opts.names[i];
            var $control = $editable.find('[data-edit-id=' + i + ']');
            if (type == 'text'){ self.toText($control, name); }
          }
          $editable.find('[data-edit-id=0]').children(':first').focus();
        },
        toText: function($control, name)
        {
          var $input = $('<input class="inline r" type="text">').attr('name', name);
          var value = $control.text();
          $input.val(value);
          $control.data('original', value);
          $control.empty().append($input);
        },
        save: function()
        {
          var data = $.extend({}, opts.postData, {});
          for(var i = 0; i < opts.names.length; ++i)
          {
            var $input = $editable.find('[name=' + opts.names[i] +']');
            data[opts.names[i]] = $input.val();
          }
          data['_method'] = 'put';
          data['authenticity_token'] = AUTH_TOKEN;
          $.post(opts.saveUrl, data, self.saved, 'json');
          return false;
        },
        saved: function(json)
        {
          if (genericResponseHandler(json)) { return; }
          self.cancelEdit(true);
          if (opts.saved) { opts.saved(); }
        }
      };
      this.inlineEdit = self;
      self.initialize(); 
    });
  };
})(jQuery);