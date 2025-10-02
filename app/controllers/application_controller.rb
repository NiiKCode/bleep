class ApplicationController < ActionController::Base
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      "application" # login, signup, password reset, etc.
    elsif controller_path.start_with?("rails_admin")
      "rails_admin/custom" # your custom admin layout
    else
      "application"
    end
  end
end
