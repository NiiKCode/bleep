require_relative "boot"

require "rails"
require "active_storage/engine"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/railtie"
# require "action_text/railtie"
require "action_view/railtie"
require "action_cable/engine"

# ✅ keep sprockets just for RailsAdmin
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Bleep
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    # ========================
    # ✅ TIME ZONE (🔥 IMPORTANT)
    # ========================
    config.time_zone = "London"

    # Store timestamps in UTC (Rails default, keep this)
    config.active_record.default_timezone = :utc

    # ========================
    # ASSETS (unchanged)
    # ========================
    config.assets.precompile = [
      "rails_admin/application.css",
      "rails_admin/application.js",
      "application.css"
    ]

    config.assets.paths << Rails.root.join("app", "assets", "images")
  end
end
