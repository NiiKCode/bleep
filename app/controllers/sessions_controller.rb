class SessionsController < ApplicationController
  def index
    # =========================
    # LOCATIONS
    # =========================

    @locations = Location.order(:name)

    @selected_location =
      @locations.find_by(id: params[:location_id]) ||
      @locations.first

    @selected_location_id = @selected_location&.id

    # =========================
    # AVAILABLE DATES
    # =========================

    @available_dates =
      ScheduledSession.available_dates_for(
        @selected_location_id
      )

    # =========================
    # SELECTED DATE
    # =========================

    @selected_date =
      parse_selected_date || @available_dates.first

    # =========================
    # SESSION TYPES
    # =========================

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
      @available_session_types.find_by(
        id: params[:session_type_id]
      ) || @available_session_types.first

    @selected_session_type_id =
      @selected_session_type&.id

    # =========================
    # SESSIONS
    # =========================

    @scheduled_sessions =
      if valid_selection?

        ScheduledSession.filtered(
          location_id: @selected_location_id,
          date: @selected_date,
          session_type_id: @selected_session_type_id
        )

      else
        ScheduledSession.none
      end

    # =========================
    # TIME SLOTS
    # =========================

    @time_slots =
      @scheduled_sessions
        .flat_map(&:time_slots)
        .select { |ts| ts.start_time >= Time.current }
        .sort_by(&:start_time)
  end

  private

  # =========================
  # DATE VALIDATION
  # =========================

  def parse_selected_date
    return unless params[:date].present?

    parsed_date = Date.parse(params[:date])

    parsed_date if @available_dates.include?(parsed_date)

  rescue ArgumentError
    nil
  end

  # =========================
  # VALID FILTERS
  # =========================

  def valid_selection?
    @selected_location_id.present? &&
      @selected_date.present? &&
      @selected_session_type_id.present?
  end
end
