class Admin::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_location, only: [:show, :edit, :update, :destroy,
                                      :schedule, :create_date]

  # --------------------------
  # Standard CRUD
  # --------------------------

  def index
    @locations = Location.all
  end

  def show
    @scheduled_sessions = @location.scheduled_sessions.includes(:session_type, :time_slots)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to admin_dashboard_path, notice: "Location created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      redirect_to admin_location_path(@location), notice: "Location updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to admin_dashboard_path, notice: "Location deleted."
  end

  # --------------------------
  # 🔽 Scheduling actions
  # --------------------------

  # GET /admin/locations/:id/schedule
  def schedule
    @past_sessions = @location.scheduled_sessions.where("date < ?", Date.today).order(date: :desc)
    @upcoming_sessions = @location.scheduled_sessions.where("date >= ?", Date.today).order(:date)
    @scheduled_session = @location.scheduled_sessions.build
  end

  # POST /admin/locations/:id/create_date
  def create_date
    @scheduled_session = @location.scheduled_sessions.build(scheduled_session_params)
    if @scheduled_session.save
      redirect_to schedule_admin_location_path(@location), notice: "New session date created."
    else
      # Rehydrate lists so form can render again with errors
      @past_sessions = @location.scheduled_sessions.where("date < ?", Date.today).order(date: :desc)
      @upcoming_sessions = @location.scheduled_sessions.where("date >= ?", Date.today).order(:date)
      render :schedule, status: :unprocessable_entity
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end

  def scheduled_session_params
    params.require(:scheduled_session).permit(:date, :session_type_id, :price)
  end

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
