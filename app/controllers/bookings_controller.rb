class BookingsController < ApplicationController
  before_action :authenticate_user!, except: [:success]

  def new
    @time_slot = TimeSlot.includes(scheduled_session: [:location, :session_type])
                         .find(params[:time_slot_id])

    @scheduled_session = @time_slot.scheduled_session
    @location = @scheduled_session.location
    @session_type = @scheduled_session.session_type

    @booking = Booking.new(time_slot: @time_slot)
  end

  def create
    @time_slot = TimeSlot.includes(scheduled_session: [:session_type])
                         .find(params.require(:booking)[:time_slot_id])

    @booking = Booking.new(
      user: current_user,
      time_slot: @time_slot
    )

    assign_partner

    if @booking.save
      session = Payments::StripeCheckoutSessionCreator.new(
        booking: @booking
      ).call

      @booking.update!(stripe_session_id: session.id)

      redirect_to session.url, allow_other_host: true
    else
      flash.now[:alert] = "Could not create booking."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @booking = current_user.bookings.find(params[:id])
  end

  # ✅ SUCCESS PAGE (Stripe redirect)
  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    @booking = Booking.find_by(
      stripe_session_id: session.id
    )

    @payment_status = session.payment_status # "paid" or "unpaid"

    # Optional safety fallback
    unless @booking
      redirect_to root_path, alert: "Booking not found."
    end
  end

  private

  def assign_partner
    return unless params[:existing_friend_id].present?

    @booking.partner_user = User.find_by(id: params[:existing_friend_id])
  end
end
