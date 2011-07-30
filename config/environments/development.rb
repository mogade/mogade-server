Mogade::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  ActionController::Base.cache_store = :memory_store
  ActionController::Base.asset_host = Proc.new { |source, request|
    request.ssl? ? Settings.ssl_cdn_url : Settings.cdn_url
  }
end