Mogade::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection    = false
  config.active_support.deprecation = :stderr
  ActionController::Base.asset_host = Proc.new { |source, request|
    request.ssl? ? Settings.ssl_cdn_url : Settings.cdn_url
  }
end
