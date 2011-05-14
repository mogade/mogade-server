unless Settings.hoptoad_key.blank?
  HoptoadNotifier.configure{|config| config.api_key = Settings.hoptoad_key }
end