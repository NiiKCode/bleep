class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @bookings = current_user.bookings
                            .includes(time_slot: { scheduled_session: :session_type })
                            .order(created_at: :desc)

    @grouped_scores = grouped_scores
  end

  private

  def grouped_scores
    current_user.bookings
      .with_scores
      .includes(time_slot: { scheduled_session: :session_type })
      .group_by do |booking|
        [
          booking.session_type.title,
          booking.partner_user&.id || :solo
        ]
      end
  end
end
