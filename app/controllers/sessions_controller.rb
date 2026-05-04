class SessionsController < ApplicationController
  def index
    # ========================
    # BASE DATA
    # ========================
    @locations = Location.order(:name)

    # ========================
    # PARAMS (CAST TYPES)
    # ========================
    @selected_location_id = params[:location_id].present? ? params[:location_id].to_i : nil

    @selected_date = begin
      Date.parse(params[:date]) if params[:date].present?
    rescue ArgumentError
      nil
    end

    @selected_session_type_id = params[:session_type_id].present? ? params[:session_type_id].to_i : nil

    # ========================
    # DEFAULT LOCATION
    # ========================
    @selected_location_id ||= @locations.first&.id

    # ========================
    # AVAILABLE DATES (FUTURE ONLY)
    # ========================
    @available_dates = []

    if @selected_location_id
      @available_dates = ScheduledSession
        .where(location_id: @selected_location_id)
        .where("date >= ?", Date.today)
        .order(:date)
        .distinct
        .pluck(:date)
    end

    # ========================
    # DEFAULT DATE
    # ========================
    if @selected_date.nil? || !@available_dates.include?(@selected_date)
      @selected_date = @available_dates.first
    end

    # ========================
    # AVAILABLE SESSION TYPES
    # ========================
    @available_session_types = []

    if @selected_location_id && @selected_date
      @available_session_types = SessionType
        .joins(:scheduled_sessions)
        .where(scheduled_sessions: {
          location_id: @selected_location_id,
          date: @selected_date
        })
        .distinct
        .order(:title)
    end

    # ========================
    # DEFAULT SESSION TYPE
    # ========================
    if @selected_session_type_id.nil? ||
       !@available_session_types.map(&:id).include?(@selected_session_type_id)
      @selected_session_type_id = @available_session_types.first&.id
    end

    # ========================
    # RESULTS
    # ========================
    @scheduled_sessions = []
    @time_slots = []

    if @selected_location_id && @selected_date && @selected_session_type_id
      @scheduled_sessions = ScheduledSession
        .includes(:location, :session_type, :time_slots)
        .where(
          location_id: @selected_location_id,
          date: @selected_date,
          session_type_id: @selected_session_type_id
        )

      @time_slots = @scheduled_sessions
        .flat_map(&:time_slots)
        .select { |ts| ts.start_time >= Time.current } # 🔥 extra safety
        .sort_by(&:start_time)
    end
  end
end
