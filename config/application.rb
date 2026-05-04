require_relative "boot"

require "rails"
require "active_storage/engine"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module Bleep
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    # ========================
    # TIME ZONE
    # ========================
    config.time_zone = "London"
    config.active_record.default_timezone = :utc

    # ========================
    # ASSETS
    # ========================
    config.assets.paths << Rails.root.join("app", "assets", "images")

    # 🔥 IMPORTANT FIX: allow importmap to resolve JS
    config.assets.paths << Rails.root.join("app/javascript")
  end
end
