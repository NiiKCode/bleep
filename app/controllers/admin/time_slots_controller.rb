class Admin::TimeSlotsController < Admin::BaseController
  before_action :set_scheduled_session
  before_action :set_time_slot, only: [:edit, :update, :destroy]

  def new
    @time_slot = @scheduled_session.time_slots.new
  end

  def create
    @time_slot = @scheduled_session.time_slots.new(time_slot_params)

    if @time_slot.save
      redirect_to schedule_admin_location_path(@scheduled_session.location),
                  notice: "Time slot added successfully."
    else
      flash.now[:alert] = @time_slot.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @time_slot.update(time_slot_params)
      redirect_to schedule_admin_location_path(@scheduled_session.location),
                  notice: "Time slot updated successfully."
    else
      flash.now[:alert] = @time_slot.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_slot.destroy
    redirect_to schedule_admin_location_path(@scheduled_session.location),
                notice: "Time slot deleted successfully."
  end

  private

  def set_scheduled_session
    @scheduled_session = ScheduledSession.find(params[:scheduled_session_id])
  end

  def set_time_slot
    @time_slot = @scheduled_session.time_slots.find(params[:id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time, :capacity)
  end
end
