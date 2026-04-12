# config/initializers/stripe.rb

Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

STRIPE_PUBLISHABLE_KEY = Rails.application.credentials.dig(:stripe, :publishable_key)
