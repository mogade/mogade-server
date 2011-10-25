(function($) {
  $.fn.validator = function(opts) {
    if (opts == 'validate') { return this[0].validator.validate(); }
    
    return this.each(function() {
      if (this.validator) { return false; }
      var rules = opts.rules;
      var $form = $(this);
      var $fields = $(':text,:password,select,textarea', $form);
      var self = {
        initialize: function() {
          if (opts.init) { self.initializeInvalidFields(); }
          $fields.each(function(i, field) {
            var $field = $(field);
            $field.blur(function() {
              if ($field.hasClass('error')) { self.validateField($field); }
            });
          });
          $form.submit(function() {return self.validate();});
        },
        initializeInvalidFields: function() {
          var isFirst = true;
          for(var name in opts.init) {
            var $field = $('[name=' + name +']', $form);
            self.markAsInvalid($field, opts.init[name]);
            if (isFirst) {
              $field.focus();
              isFirst = false;
            }
          }
        },
        validate: function() {
          var valid = true;
          $fields.each(function(i, field) {
            var $field = $(field);
            if (!self.validateField($field) && valid) {
              valid = false;
              $field.focus();
            }
          });
          return valid;
        },
        validateField: function($field) {
          var ruleList = rules[$field.attr('name')];
          if (!ruleList){return true;}
          var length = ruleList.length;
          var message = ruleList[length-1];
          for(var i = 0; i < length-1; ++i) {
            if (!self.validateFieldWithRule($field, ruleList[i], message)) { return false; }
          }
          return true;
        },
        validateFieldWithRule: function($field, rule, message) {
          if (!rule || $field.attr('disabled')) { return true; }
          var value = $field.val();
          var isValid = true;
          if (rule.required && value.length == 0) { isValid = false; }
          else if (!rule.required && value.length == 0 && !rule.eqTo) { isValid = true; }
          else if (rule.min && rule.min > value.length) { isValid = false; }
          else if (rule.max && rule.max < value.length) { isValid = false; }
          // contributed by Scott Gonzalez: http://projects.scottsplayground.com/iri/
          else if (rule.email) { isValid = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(value); }
          // contributed by Scott Gonzalez: http://projects.scottsplayground.com/iri/                    
          else if (rule.url) { isValid = /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value); }
          else if (rule.number) { isValid = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(value); }
          else if (rule.digits) { isValid = /^\d+$/.test(value); }
          else if (rule.regex) { isValid = new RegExp(rule.regex).test(value); }
          else if (rule.eqTo) { isValid = $('[name$=' + rule.eqTo + ']', $form).val() == value; }
          else if (rule.eq) { isValid = value == rule.eq; }
          else if (rule.bexc) { isValid = value > rule.bexc[0] && value < rule.bexc[1]; }
          else if (rule.binc) { isValid = value >= rule.binc[0] && value <= rule.binc[1]; }                                                            
          if (!isValid) { self.markAsInvalid($field, message); }
          else { self.markAsValid($field); }
          return isValid;
        },
        markAsInvalid: function($field, message) {
          var $tip = $field.siblings('.error');
          if ($tip.length == 0 && message) {
            $tip = $('<label>').addClass('error').attr('for', $field.attr('name'));                        
            $field.after($tip);
          }
          $tip.text(message);
          $field.addClass('error');
          $tip.show();
        },
        markAsValid: function($field) {
          $field.siblings('.error').remove();
          $field.removeClass('error');
        }
      }
      this.validator = self;
      self.initialize();
    });
  };
})(jQuery);

(function($) {
  $.fn.textAreaLength = function(maxlength) {
    return this.each(function() {
      if (this.textAreaLength) { return false; }
      var $this = $(this);
      var $container = $this.siblings('.charCounter');
      var self = {
        initialize: function() {
          $this.attr('maxlength', maxlength)
          $this.keyup(self.updateCount);
          self.updateCount();
        },
        updateCount: function() {
          $container.html($this.val().length + " / " + maxlength);
        }
      }
      this.textAreaLength = self;
      self.initialize();
    });
  };
})(jQuery);