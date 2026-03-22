class SessionsController < ApplicationController
  def index
    @locations = Location.order(:name)

    @selected_location_id = params[:location_id].presence
    @selected_date = params[:date].presence
    @selected_session_type_id = params[:session_type_id].presence

    # For dropdowns
    @available_dates = []
    @available_session_types = []

    # For results
    @scheduled_sessions = []
    @time_slots = []

    # 1) If location selected → populate available dates
    if @selected_location_id
      @available_dates = ScheduledSession
        .where(location_id: @selected_location_id)
        .where("date >= ?", Date.today)
        .order(:date)
        .distinct
        .pluck(:date)
    end

    # 2) If location + date selected → populate session types
    if @selected_location_id && @selected_date
      @available_session_types = SessionType
        .joins(:scheduled_sessions)
        .where(scheduled_sessions: { location_id: @selected_location_id, date: @selected_date })
        .distinct
        .order(:title)
    end

    # 3) If all 3 selected → show scheduled sessions + time slots
    if @selected_location_id && @selected_date && @selected_session_type_id
      @scheduled_sessions = ScheduledSession
        .includes(:location, :session_type, :time_slots)
        .where(
          location_id: @selected_location_id,
          date: @selected_date,
          session_type_id: @selected_session_type_id
        )

      @time_slots = @scheduled_sessions.flat_map(&:time_slots).sort_by(&:start_time)
    end
  end
end
