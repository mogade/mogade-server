module ApplicationHelper
  def include_js_bundle(name)
    files = Rails.env.development? ? Asset.js(name) : name
    javascript_include_tag files
  end
  
  def include_css_bundle(name)
    files = Rails.env.development? ? Asset.css(name) : name
    stylesheet_link_tag files
  end

  def ssl_url(path)
    return path if request.ssl? || request.local?
    'https://' + request.host_with_port + path
  end
  
  def validation_init(model)
    init = {}
    model.errors.each_pair do |k, v|
      init[k] = v[0]
    end
    return init.to_json
  end
  
  def validation_of(klass)
    rules = {}
    klass.validators.each do |v|   
      name = v.attributes[0] 
      if v.class.to_s =~ /ConfirmationValidator/   
        rules.merge!(confirm_validator_to_json(name, v))
      else
        rules[name] = [] unless rules.has_key?(name)
        validator_to_json(rules[name], v.options)
      end
    end
    return rules.to_json
  end
  
  private 
  def confirm_validator_to_json(name, validator)
    {'confirm_' + name.to_s => [{:eqTo => name}, validator.options[:message]]}
  end
  def validator_to_json(rule, options)
    rule << {:required => !options[:allow_blank]} if options.has_key?(:allow_blank)
    rule << {:min => options[:minimum]} if options.has_key?(:minimum)
    rule << {:max => options[:maximum]} if options.has_key?(:maximum)
    rule << {:regex => options[:with].source} if options.has_key?(:with)
    rule << options[:message]
  end
end
