require Rails.root.join("lib/rails_admin/schedule_location.rb")

RailsAdmin.config do |config|
  config.asset_source = :importmap

  # 🔐 Devise auth
  config.authenticate_with { warden.authenticate! scope: :user }
  config.current_user_method(&:current_user)

  # 🔑 Only admins allowed
  config.authorize_with do
    redirect_to main_app.root_path unless current_user&.admin?
  end

  # 🏷 Branding
  config.main_app_name = ["Bleep", "Admin"]

  # 🖼 Use custom layout
  config.parent_controller = "::ApplicationController"

  # 📂 Navigation labels
  config.model 'Location' do
    navigation_label 'Fitness Setup'
    weight -1
  end

  config.model 'SessionType' do
    navigation_label 'Fitness Setup'
    weight 0
  end

  config.model 'ScheduledSession' do
    navigation_label 'Scheduling'
  end

  config.model 'TimeSlot' do
    navigation_label 'Scheduling'
  end

  config.model 'Booking' do
    navigation_label 'User Activity'
  end

  config.model 'Score' do
    navigation_label 'User Activity'
  end

  config.model 'User' do
    navigation_label 'Accounts'
    exclude_fields :encrypted_password, :reset_password_token

    configure :password do
      hide
    end

    object_label_method :email

    # 🚫 Prevent deleting users
    configure :_destroy do
      hide
    end
  end

  # ⚙️ Actions
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    # 🆕 Custom action (from lib/rails_admin/schedule_location.rb)
    schedule_location
  end
end
