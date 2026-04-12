# app/services/payments/stripe_checkout_session_creator.rb

module Payments
  class StripeCheckoutSessionCreator
    def initialize(booking:)
      @booking = booking
    end

    def call
      Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        mode: 'payment',

        line_items: [{
          price_data: {
            currency: 'gbp',
            product_data: {
              name: @booking.session_type.title
            },
            unit_amount: (@booking.price * 100).to_i
          },
          quantity: 1
        }],

        success_url: success_url,
        cancel_url: cancel_url,

        metadata: {
          booking_id: @booking.id
        }
      )
    end

    private

    def success_url
      Rails.application.routes.url_helpers.success_bookings_url(
        host: default_host
      ) + "?session_id={CHECKOUT_SESSION_ID}"
    end

    def cancel_url
      Rails.application.routes.url_helpers.new_booking_url(
        host: default_host
      )
    end

    def default_host
      Rails.application.config.action_mailer.default_url_options&.dig(:host) || "localhost:3000"
    end
  end
end
