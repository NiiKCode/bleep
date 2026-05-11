class PagesController < ApplicationController
  def home
    @cities = Location.distinct.order(:city).pluck(:city)

    @selected_city =
      params[:city].presence || @cities.first

    @locations =
      Location.where(city: @selected_city).order(:name)

    @selected_location =
      @locations.find_by(id: params[:location_id]) ||
      @locations.first

    @selected_location_id = @selected_location&.id

    @available_dates =
      ScheduledSession.available_dates_for(@selected_location_id)

    @selected_date =
      parse_selected_date || @available_dates.first

    @available_session_types =
      if @selected_location_id && @selected_date
        ScheduledSession.available_session_types(
          @selected_location_id,
          @selected_date
        )
      else
        SessionType.none
      end

    @selected_session_type =
      @available_session_types.find_by(id: params[:session_type_id]) ||
      @available_session_types.first

    @scheduled_sessions =
      if valid_selection?
        ScheduledSession.filtered(
          location_id: @selected_location_id,
          date: @selected_date,
          session_type_id: @selected_session_type.id
        )
      else
        ScheduledSession.none
      end

    @time_slots =
      TimeSlot
        .joins(:scheduled_session)
        .where(scheduled_sessions: {
          id: @scheduled_sessions.pluck(:id)
        })
        .where("start_time >= ?", Time.current)
        .order(:start_time)
  end

  private

  def parse_selected_date
    return unless params[:date].present?

    parsed_date = Date.parse(params[:date])

    parsed_date if @available_dates.include?(parsed_date)

  rescue ArgumentError
    nil
  end

  def valid_selection?
    @selected_location_id &&
      @selected_date &&
      @selected_session_type.present?
  end
end
