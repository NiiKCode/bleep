# lib/rails_admin/schedule_location.rb
module RailsAdmin
  module Config
    module Actions
      class ScheduleLocation < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        # Only applies to individual Location records
        register_instance_option :collection? do
          false
        end

        register_instance_option :member? do
          true
        end

        # What happens when clicked
        register_instance_option :controller do
          proc do
            redirect_to main_app.schedule_admin_location_path(@object)
          end
        end

        # Add a nice calendar icon
        register_instance_option :link_icon do
          "icon-calendar"
        end
      end
    end
  end
end
