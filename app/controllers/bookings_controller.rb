class BookingsController < ApplicationController
  before_action :authenticate_user!, except: [:success]
  before_action :set_time_slot_and_dependencies, only: [:new, :create]

  def new
    @booking = Booking.new(time_slot: @time_slot)
  end

  def create
    @booking = Booking.new(
      user: current_user,
      time_slot: @time_slot,
      status: "pending" # explicit
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

  # ========================
  # SCORE ACTIONS
  # ========================
  def edit_score
    @booking = current_user.bookings.find(params[:id])
  end

  def update_score
    @booking = current_user.bookings.find(params[:id])

    unless @booking.completed?
      redirect_to account_path, alert: "Session not completed"
      return
    end

    if @booking.update(score_params)
      redirect_to account_path, notice: "Score saved"
    else
      render :edit_score, status: :unprocessable_entity
    end
  end

  # ========================
  # STRIPE SUCCESS (🔥 FIXED)
  # ========================
  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    @booking = Booking.find_by(
      stripe_session_id: session.id
    )

    unless @booking
      redirect_to root_path, alert: "Booking not found."
      return
    end

    # ✅ THIS IS THE KEY FIX
    if session.payment_status == "paid"
      @booking.update!(
        status: "paid"
      )
    end

    @payment_status = session.payment_status
  end

  private

  def set_time_slot_and_dependencies
    time_slot_id =
      params[:time_slot_id] ||
      params.dig(:booking, :time_slot_id)

    @time_slot = TimeSlot
      .includes(scheduled_session: [:location, :session_type])
      .find_by(id: time_slot_id)

    return unless @time_slot

    @scheduled_session = @time_slot.scheduled_session
    @location = @scheduled_session&.location
    @session_type = @scheduled_session&.session_type
  end

  def assign_partner
    return unless params[:existing_friend_id].present?

    @booking.partner_user = User.find_by(id: params[:existing_friend_id])
  end

  def score_params
    params.require(:booking).permit(:score)
  end
end
