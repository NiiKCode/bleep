class PagesController < ApplicationController
  def home
    load_cities
    load_locations
    load_dates
    load_scheduled_sessions
    load_time_slots
  end

  def about
  end

  private

  # =========================
  # CITIES
  # =========================

  def load_cities
    @cities =
      Location
        .distinct
        .order(:city)
        .pluck(:city)

    @selected_city =
      params[:city].presence || @cities.first
  end

  # =========================
  # LOCATIONS
  # =========================

  def load_locations
    @locations =
      Location
        .where(city: @selected_city)
        .order(:name)

    @selected_location =
      @locations.find_by(
        id: params[:location_id]
      ) || @locations.first

    @selected_location_id =
      @selected_location&.id
  end

  # =========================
  # DATES
  # =========================

  def load_dates
    @available_dates =
      if @selected_location_id.present?

        ScheduledSession.available_dates_for_location(
          @selected_location_id
        )

      else
        []
      end

    @selected_date =
      parse_selected_date || @available_dates.first
  end

  # =========================
  # SESSIONS
  # =========================

  def load_scheduled_sessions
    @scheduled_sessions =
      if valid_selection?

        ScheduledSession.for_location_and_date(
          location_id: @selected_location_id,
          date: @selected_date
        )

      else
        ScheduledSession.none
      end
  end

  # =========================
  # TIME SLOTS
  # =========================

  def load_time_slots
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
      @selected_date.present?
  end
end
