class WebhooksController < ApplicationController
  # Stripe does not send CSRF tokens
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret =
      ENV['STRIPE_WEBHOOK_SECRET'] ||
      Rails.application.credentials.dig(:stripe, :webhook_secret)

    event = Stripe::Webhook.construct_event(
      payload, sig_header, endpoint_secret
    )

    case event.type
    when 'checkout.session.completed'
      handle_checkout_session(event.data.object)
    end

    head :ok

  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end

  private

  def handle_checkout_session(session)
    booking = Booking.find_by(id: session.metadata.booking_id)

    return unless booking

    # ✅ Prevent double-processing (IMPORTANT)
    return if booking.paid?

    booking.update!(
      status: "paid",
      stripe_payment_intent_id: session.payment_intent
    )
  end
end
