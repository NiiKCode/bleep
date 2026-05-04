require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests
  config.enable_reloading = false

  # Eager load code on boot
  config.eager_load = true

  # Disable full error reports
  config.consider_all_requests_local = false

  # Enable caching
  config.action_controller.perform_caching = true

  # ✅ Serve static files (REQUIRED for Render)
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Do not fallback to asset pipeline
  config.assets.compile = true

  # Active Storage (local for now — OK for MVP)
  config.active_storage.service = :local

  # Force SSL
  config.force_ssl = true

  # Logging
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Mailer (IMPORTANT for Devise links)
  config.action_mailer.default_url_options = {
    host: "bleep.fit"
  }

  config.action_mailer.perform_caching = false

  # I18n fallbacks
  config.i18n.fallbacks = true

  # Disable deprecation logging
  config.active_support.report_deprecations = false

  # Do not dump schema
  config.active_record.dump_schema_after_migration = false
end
