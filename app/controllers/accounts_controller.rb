class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @bookings = current_user.bookings
                            .includes(time_slot: { scheduled_session: :session_type })
                            .order(created_at: :desc)
  end
end
