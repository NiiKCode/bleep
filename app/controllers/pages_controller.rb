class PagesController < ApplicationController
  def home
    # =========================
    # CITIES
    # =========================

    @cities =
      Location
        .distinct
        .order(:city)
        .pluck(:city)

    @selected_city =
      params[:city].presence || @cities.first

    # =========================
    # LOCATIONS
    # =========================

    @locations =
      Location
        .where(city: @selected_city)
        .order(:name)

    @selected_location =
      @locations.find_by(id: params[:location_id]) ||
      @locations.first

    @selected_location_id =
      @selected_location&.id

    # =========================
    # SESSION TYPES
    # =========================

    @available_session_types =
      if @selected_location_id.present?
        ScheduledSession.available_session_types(
          @selected_location_id
        )
      else
        SessionType.none
      end

    @selected_session_type =
      @available_session_types.find_by(
        id: params[:session_type_id]
      ) || @available_session_types.first

    @selected_session_type_id =
      @selected_session_type&.id

    # =========================
    # DATES
    # =========================

    @available_dates =
      if @selected_location_id.present? &&
         @selected_session_type_id.present?

        ScheduledSession.available_dates_for(
          @selected_location_id,
          @selected_session_type_id
        )

      else
        []
      end

    @selected_date =
      parse_selected_date || @available_dates.first

    # =========================
    # SESSIONS
    # =========================

    @scheduled_sessions =
      if valid_selection?

        ScheduledSession.filtered(
          location_id: @selected_location_id,
          session_type_id: @selected_session_type_id,
          date: @selected_date
        )

      else
        ScheduledSession.none
      end

    # =========================
    # TIME SLOTS
    # =========================

    @time_slots =
      TimeSlot
        .joins(:scheduled_session)
        .where(
          scheduled_sessions: {
            id: @scheduled_sessions.pluck(:id)
          }
        )
        .where("start_time >= ?", Time.current)
        .order(:start_time)
  end

  def about
  end

  private

  # =========================
  # DATE VALIDATION
  # =========================

  def parse_selected_date
    return unless params[:date].present?

    parsed_date =
      Date.parse(params[:date])

    parsed_date if @available_dates.include?(parsed_date)

  rescue ArgumentError
    nil
  end

  # =========================
  # VALID FILTERS
  # =========================

  def valid_selection?
    @selected_location_id.present? &&
      @selected_session_type_id.present? &&
      @selected_date.present?
  end
end
