class PagesController < ApplicationController
  def home
    # CITY
    @cities = Location.distinct.order(:city).pluck(:city)
    @selected_city = params[:city].presence || @cities.first

    # LOCATION
    @locations = Location.where(city: @selected_city).order(:name)
    @selected_location = @locations.find_by(id: params[:location_id]) || @locations.first
    @selected_location_id = @selected_location&.id

    # DATE (✅ FIXED)
    @available_dates = ScheduledSession
      .where(location_id: @selected_location_id)
      .distinct
      .order(:date)
      .pluck(:date)

    @selected_date =
      if params[:date].present?
        Date.parse(params[:date]) rescue nil
      else
        @available_dates.first
      end

    @selected_date ||= @available_dates.first

    # SESSION TYPES
    @available_session_types =
      if @selected_location_id && @selected_date
        SessionType
          .joins(:scheduled_sessions)
          .where(scheduled_sessions: {
            location_id: @selected_location_id,
            date: @selected_date
          })
          .distinct
          .order(:title)
      else
        SessionType.none
      end

    @selected_session_type =
      @available_session_types.find_by(id: params[:session_type_id]) ||
      @available_session_types.first

    @selected_session_type_id = @selected_session_type&.id

    # SESSIONS
    @scheduled_sessions =
      if @selected_location_id && @selected_date && @selected_session_type_id
        ScheduledSession
          .includes(:location, :session_type, :time_slots)
          .where(
            location_id: @selected_location_id,
            date: @selected_date,
            session_type_id: @selected_session_type_id
          )
          .order(date: :asc)
      else
        ScheduledSession.none
      end

    # TIME SLOTS
    @time_slots =
      if @scheduled_sessions.any?
        TimeSlot
          .joins(:scheduled_session)
          .where(scheduled_sessions: { id: @scheduled_sessions.pluck(:id) })
          .order(:start_time)
      else
        TimeSlot.none
      end
  end
end
