# config/initializers/assets.rb

Rails.application.config.assets.version = "1.0"

# ✅ Add fonts path so Rails can find your .woff2 files
Rails.application.config.assets.paths << Rails.root.join("app/assets/fonts")

# ✅ Precompile font files (important for production)
Rails.application.config.assets.precompile += %w[
  *.woff2
]
