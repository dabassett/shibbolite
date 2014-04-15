require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "shibbolite"

module Dummy
  class Application < Rails::Application
    I18n.config.enforce_available_locales = false
  end
end

