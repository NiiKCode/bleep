Rails.application.routes.draw do
  # ========================
  # AUTH
  # ========================
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # ========================
  # ROOT
  # ========================
  root "pages#home"

  # ========================
  # WEBHOOKS
  # ========================
  post "/webhooks/stripe", to: "webhooks#stripe"

  # ========================
  # SESSIONS (booking flow)
  # ========================
  resources :sessions, only: [:index]

  # ========================
  # BOOKINGS
  # ========================
  resources :bookings, only: [:new, :create, :show] do
    collection do
      get :success
    end

    member do
      get :edit_score
      patch :update_score
    end
  end

  # ========================
  # ACCOUNT
  # ========================
  resource :account, only: [:show]

  # ========================
  # FRIENDS
  # ========================
  resources :friends, only: [:create]

  # ========================
  # USER SEARCH
  # ========================
  resources :users, only: [] do
    collection do
      get :search
    end
  end

  # ========================
  # ADMIN AREA
  # ========================
  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"

    # ✅ FIXED: allow :show so /admin/locations/:id works
    resources :locations do
      member do
        get :schedule
        post :create_date
        delete "delete_scheduled_session/:session_id",
               to: "locations#destroy_scheduled_session",
               as: :delete_scheduled_session
      end
    end

    # same fix here (optional but recommended)
    resources :session_types

    resources :scheduled_sessions do
      resources :time_slots, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
