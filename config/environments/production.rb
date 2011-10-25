Mogade::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = Logger::ERROR
  config.action_controller.asset_host = Proc.new { |source, request|
    request.ssl? ? Settings.ssl_cdn_url : Settings.cdn_url
  }
end