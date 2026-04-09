# config/initializers/assets.rb

Rails.application.config.assets.version = "1.0"

# Ensure RailsAdmin assets are compiled
Rails.application.config.assets.precompile += %w[
  rails_admin/application.js
  rails_admin/application.css
]

# ✅ Add fonts path so Rails can find your .woff2 files
Rails.application.config.assets.paths << Rails.root.join("app/assets/fonts")

# ✅ Precompile font files (important for production)
Rails.application.config.assets.precompile += %w[
  *.woff2
]
