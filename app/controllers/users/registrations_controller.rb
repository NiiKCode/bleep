class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # ========================
  # SIGN UP PARAMS
  # ========================
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name,
      :date_of_birth
    ])
  end

  # ========================
  # ACCOUNT UPDATE PARAMS
  # ========================
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name
    ])
  end

  # ========================
  # REDIRECT AFTER UPDATE
  # ========================
  def after_update_path_for(resource)
    account_path
  end
end
