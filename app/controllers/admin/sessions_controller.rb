# app/controllers/admin/sessions_controller.rb
module Admin
  class SessionsController < ApplicationController
    before_action :set_location, only: [:new, :create]
    before_action :set_session, only: [:edit, :update, :destroy]

    def new
      @session = @location.sessions.build
    end

    def create
      @session = @location.sessions.build(session_params)
      if @session.save
        redirect_to admin_location_path(@location), notice: "Session created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @session.update(session_params)
        redirect_to admin_location_path(@session.location), notice: "Session updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      location = @session.location
      @session.destroy
      redirect_to admin_location_path(location), notice: "Session deleted successfully."
    end

    private

    def set_location
      @location = Location.find(params[:location_id])
    end

    def set_session
      @session = Session.find(params[:id])
    end

    def session_params
      params.require(:session).permit(:title, :description, :date, :price, :location_name)
    end
  end
end
