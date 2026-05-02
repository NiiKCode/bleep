class ApplicationController < ActionController::Base
  layout :layout_by_resource

  before_action :store_user_location!, if: :storable_location?

  protected

  # Store last visited URL
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Only store safe GET requests
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  # Redirect after login
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  # Redirect after logout
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def layout_by_resource
    if devise_controller?
      "application"
    elsif controller_path.start_with?("rails_admin")
      "rails_admin/custom"
    else
      "application"
    end
  end
end
