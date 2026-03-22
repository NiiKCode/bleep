class FriendsController < ApplicationController
  before_action :authenticate_user!

  def create
    email = params[:email].to_s.strip.downcase

    return render json: { error: "Email required" }, status: :unprocessable_entity if email.blank?

    friend_user = User.find_by(email: email)

    # ❌ Must already exist
    return render json: { error: "User not found" }, status: :not_found unless friend_user

    # ❌ Prevent adding yourself
    return render json: { error: "You cannot add yourself" }, status: :unprocessable_entity if friend_user == current_user

    # ✅ BI-DIRECTIONAL FRIENDSHIP (no duplicates)
    unless current_user.friends.include?(friend_user)
      current_user.friendships.create!(friend: friend_user)
      friend_user.friendships.create!(friend: current_user)
    end

    render json: {
      id: friend_user.id,
      email: friend_user.email,
      initials: friend_user.try(:initials) || friend_user.email.first.upcase
    }
  end
end
