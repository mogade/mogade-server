(function($) {
  $.fn.resetForm = function() {
    return this.each(function() {
      var $form = $(this);
      $(':password, :text, textarea', $form).val('');
      $('input.numeric', $form).numeric('reset'); 
    });
  };
})(jQuery);
