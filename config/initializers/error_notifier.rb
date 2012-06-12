unless Settings.notifier.nil?
  ErrorNotifier.configure do |config|
    config.url = Settings.notifier['url']
    config.site = Settings.notifier['site']
  end
end
