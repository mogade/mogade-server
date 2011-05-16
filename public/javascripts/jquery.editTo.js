(function($) 
{
  var defaults = { to: null, map: {}, url: null};
  $.fn.editTo = function(options, commandOptions) 
  {
    var opts = $.extend({}, defaults, options);
    return this.each(function() 
    {
      if (this.editTo) { return false; }
      var table = this;
      var $table = $(this);
      var $to = $(opts.to);
      var $row = null
      var self =
      {   
        initialize: function()
        {
          $table.delegate('td.edit', 'click', self.clicked);
          $to.delegate('input.reset', 'click', self.reset);
        },
        clicked: function()
        {
          var isFirst = true;
          $row = $(this).parent();
          for(var key in opts.map)
          {
            var $cell = $row.children(':eq(' + key + ')');
            var $field = $('#' + opts.map[key]);
            
            if ($field.is('select')) { self.setSelect($field, $cell.attr('rel')); }
            else { $field.val($cell.text()); }
            
            if (isFirst){ $field.focus(); isFirst = false; }
          }
          self.swapTitle(/Add/, 'Edit');
          $to.find(':submit').val('edit').click(self.submitClicked)
          if ($to.find('.reset').length == 0) 
          {
            $to.find('.buttons').append($('<input type="button" class="button r reset" value="cancel" />'));
          }
        },
        setSelect: function($field, value)
        {
          $field.val(value);
        },
        submitClicked: function()
        {
          $to.attr('action', opts.url + '/' + $row.data('id'));
          $to.append($('<input>', {type: 'hidden', name: '_method', value: 'put'}));
          $to.append($('<input>', {type: 'hidden', name: 'authenticity_token', value: AUTH_TOKEN}));
          return true;
        },
        swapTitle: function(pattern, replace)
        {
          var $title = $to.find('h3');
          $title.text($title.text().replace(pattern,  replace));
        },
        reset: function()
        {
          self.swapTitle(/Edit/, 'Add');
          $to.find('.reset').remove();
          $to.find(':submit').unbind('click', self.actual_click).val('add');
          $to.resetForm();
          $row = null;
        },
      };
      this.editTo = self;
      self.initialize();
    });
  };
})(jQuery);