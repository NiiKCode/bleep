class Admin::DashboardController < Admin::BaseController
  def index
    @locations = Location.all.order(:name)
    @session_types = SessionType.all.order(:title)
  end
end
