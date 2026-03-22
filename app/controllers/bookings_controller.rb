class BookingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @time_slot = TimeSlot.includes(scheduled_session: [:location, :session_type])
                         .find(params[:time_slot_id])

    @scheduled_session = @time_slot.scheduled_session
    @location = @scheduled_session.location
    @session_type = @scheduled_session.session_type

    @booking = Booking.new(time_slot: @time_slot)
  end

  def create
    @time_slot = TimeSlot.find(params.require(:booking)[:time_slot_id])

    @booking = Booking.new(
      user: current_user,
      time_slot: @time_slot
    )

    assign_partner

    if @booking.save
      redirect_to @booking, notice: "Booking confirmed!"
    else
      redirect_to new_booking_path(time_slot_id: @time_slot.id),
                  alert: "Could not create booking."
    end
  end

  def show
    @booking = current_user.bookings.find(params[:id])
  end

  private

  # ========================
  # PARTNER ASSIGNMENT (LIVE SEARCH ONLY)
  # ========================
  def assign_partner
    return unless params[:existing_friend_id].present?

    @booking.partner_user = User.find_by(id: params[:existing_friend_id])
  end
end
