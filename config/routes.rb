Rails.application.routes.draw do
  # RailsAdmin
  mount RailsAdmin::Engine => "/rails_admin", as: "rails_admin"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "pages#home"

  resources :sessions, only: [:index]

  # ✅ BOOKINGS
  resources :bookings, only: [:new, :create, :show]

  # ✅ FRIENDS (REQUIRED for persistence)
  resources :friends, only: [:create]

  # ✅ LIVE USER SEARCH
  resources :users, only: [] do
    collection do
      get :search
    end
  end

  # ✅ ADMIN AREA
  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :locations, except: [:show] do
      member do
        get :schedule
        post :create_date
        delete "delete_scheduled_session/:session_id",
               to: "locations#destroy_scheduled_session",
               as: :delete_scheduled_session
      end
    end

    resources :session_types, except: [:show]

    resources :scheduled_sessions do
      resources :time_slots, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
