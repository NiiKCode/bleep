class PagesController < ApplicationController
  def home
    @cities = Location.distinct.order(:city).pluck(:city)

    # Pick a default city
    @selected_city = params[:city].presence || @cities.first

    # Locations for that city
    @locations = Location.where(city: @selected_city).order(:name)

    # Pick a default location
    @selected_location_id = params[:location_id].presence || @locations.first&.id

    # Dates for that location
    @available_dates = ScheduledSession
      .where(location_id: @selected_location_id)
      .where(date: Date.today..)
      .distinct
      .order(:date)
      .pluck(:date)

    # Pick a default date
    @selected_date = params[:date].presence || @available_dates.first

    # Session types for that location+date
    @available_session_types = SessionType
      .joins(:scheduled_sessions)
      .where(scheduled_sessions: { location_id: @selected_location_id, date: @selected_date })
      .distinct
      .order(:title)

    # Pick a default session type
    @selected_session_type_id = params[:session_type_id].presence || @available_session_types.first&.id

    # Scheduled sessions filtered
    @scheduled_sessions = ScheduledSession
      .includes(:location, :session_type, :time_slots)
      .where(location_id: @selected_location_id, date: @selected_date, session_type_id: @selected_session_type_id)
      .order(date: :asc)

    @time_slots = TimeSlot
      .joins(:scheduled_session)
      .where(scheduled_sessions: { id: @scheduled_sessions.pluck(:id) })
      .order(:start_time)
  end
end
