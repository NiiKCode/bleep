# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :authenticate_user!

  def search
    query = params[:q].to_s.strip.downcase

    users = User
              .where("LOWER(email) LIKE ?", "%#{query}%")
              .where.not(id: current_user.id)
              .limit(5)

    render json: users.select(:id, :email, :first_name, :last_name)
  end
end
