class Admin::TimeSlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_scheduled_session

  def new
    @time_slot = @scheduled_session.time_slots.new
  end

  def create
    @time_slot = @scheduled_session.time_slots.new(time_slot_params)
    if @time_slot.save
      redirect_to schedule_admin_location_path(@scheduled_session.location),
                  notice: "Time slot added successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_scheduled_session
    @scheduled_session = ScheduledSession.find(params[:scheduled_session_id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time, :capacity)
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end
