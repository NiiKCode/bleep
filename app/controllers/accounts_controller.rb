class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # =====================================================
    # ALL BOOKINGS
    # =====================================================
    @bookings = current_user.bookings
                            .includes(time_slot: { scheduled_session: [:session_type, :location] })
                            .order(created_at: :desc)

    # =====================================================
    # ✅ UPCOMING (using scope)
    # =====================================================
    @upcoming_bookings = current_user.bookings
                                     .joins(:time_slot)
                                     .includes(time_slot: { scheduled_session: [:session_type, :location] })
                                     .where(status: "paid")
                                     .where("time_slots.start_time > ?", Time.current)
                                     .order("time_slots.start_time ASC")

    # =====================================================
    # ✅ COMPLETED (using scope)
    # =====================================================
    @completed_bookings = current_user.bookings
                                      .joins(:time_slot)
                                      .includes(time_slot: { scheduled_session: [:session_type, :location] })
                                      .where("time_slots.end_time < ?", Time.current)
                                      .order("time_slots.start_time DESC")

    # =====================================================
    # CHART DATA
    # =====================================================
    scored_bookings = current_user.bookings
                                  .with_scores
                                  .completed_sessions
                                  .includes(:partner_user, time_slot: { scheduled_session: :session_type })

    @chart_data = build_chart_data(scored_bookings)
  end

  private

  def build_chart_data(bookings)
    bookings
      .group_by { |b| b.session_type.title }
      .transform_values do |session_bookings|

        session_bookings
          .group_by { |b| competitor_label(b) }
          .transform_values do |entries|

            entries
              .sort_by(&:session_date)
              .map do |b|
                {
                  x: b.session_date.to_time.iso8601,
                  y: b.score.to_f
                }
              end
          end
      end
  end

  def competitor_label(booking)
    if booking.partner_user
      "#{current_user.initials}+#{booking.partner_user.initials}"
    else
      current_user.initials
    end
  end
end
