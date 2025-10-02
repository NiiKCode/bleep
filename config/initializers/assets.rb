# config/initializers/assets.rb
Rails.application.config.assets.version = "1.0"

# Ensure RailsAdmin assets are compiled
Rails.application.config.assets.precompile += %w[
  rails_admin/application.js
  rails_admin/application.css
]
