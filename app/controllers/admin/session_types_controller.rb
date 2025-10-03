class Admin::SessionTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_session_type, only: [:edit, :update, :destroy]

  def index
    @session_types = SessionType.all.order(:title)
  end

  def new
    @session_type = SessionType.new
  end

  def create
    @session_type = SessionType.new(session_type_params)
    if @session_type.save
      redirect_to admin_dashboard_path, notice: "Session type created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @session_type.update(session_type_params)
      redirect_to admin_dashboard_path, notice: "Session type updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @session_type.destroy
    redirect_to admin_dashboard_path, notice: "Session type deleted."
  end

  private

  def set_session_type
    @session_type = SessionType.find(params[:id])
  end

  def session_type_params
    params.require(:session_type).permit(:title, :description)
  end

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
