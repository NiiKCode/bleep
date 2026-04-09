class ApplicationController < ActionController::Base
  layout :layout_by_resource

  before_action :store_user_location!, if: :storable_location?

  protected

  # Store the last visited URL so Devise can redirect back after login
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Only store navigational GET requests
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  # After login, redirect user back to where they were trying to go
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

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
