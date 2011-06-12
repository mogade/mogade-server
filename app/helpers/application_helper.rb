module ApplicationHelper
  def include_js_bundle(name)
    files = Rails.env.development? ? Asset.js(name) : name
    javascript_include_tag files
  end
  
  def include_css_bundle(name)
    files = Rails.env.development? ? Asset.css(name) : name
    stylesheet_link_tag files
  end
  
  def enum_drop_down(name, enum, selected, *ignore)
    values = enum.lookup.reject{|pair| ignore.include?(pair[1])}
    ("<select name=\"#{name}\" id=\"#{name}\">" + options_for_select(values, selected) + "</select>").html_safe
  end
  
  def nl2br(string)
    h(string).gsub(/\n/, '<br />').html_safe
  end
  
  def profile_image_root
    (request.ssl? ? 'https://' : 'http://') + Settings.aws_root_path
  end

  def profile_image(profile, index)
    return '/images/trans.gif' unless profile_has_image(profile, index)
    profile_image_root + profile.images[index]
  end
  
  def profile_thumb(profile, index)
    return '/images/trans.gif' unless profile_has_image(profile, index)
    profile_image_root + 'thumb' + profile.images[index]
  end
  
  def profile_has_image(profile, index)
    !profile.images.nil? && !profile.images[index].nil?
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
    rule << {:digits => true} if options.has_key?(:only_integer)
    rule << {:binc => [options[:in].begin, options[:in].end]} if options.has_key?(:in)
    rule << options[:message]
  end
end
