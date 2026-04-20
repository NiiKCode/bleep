Rails.application.routes.draw do
  get 'accounts/show'

  # RailsAdmin
  mount RailsAdmin::Engine => "/rails_admin", as: "rails_admin"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "pages#home"

  # ✅ STRIPE WEBHOOK
  post '/webhooks/stripe', to: 'webhooks#stripe'

  resources :sessions, only: [:index]

  # ✅ BOOKINGS
  resources :bookings, only: [:new, :create, :show] do
    collection do
      get :success
    end

    # ✅ ADD THIS BLOCK
    member do
      get :edit_score
      patch :update_score
    end
  end

  # ✅ ACCOUNT PAGE
  resource :account, only: [:show]

  # ✅ FRIENDS
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
