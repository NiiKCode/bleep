class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @locations = Location.all.order(:name)
    @session_types = SessionType.all.order(:title)
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
