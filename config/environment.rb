require File.expand_path('../application', __FILE__)
require 'postmark'

Mogade::Application.initialize!
Postmark.api_key = Settings.postmark_key