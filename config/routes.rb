Rails.application.routes.draw do
  # RailsAdmin lives under a different path
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  devise_for :users

  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :locations, except: [:show] do
      member do
        get :schedule       # 👈 custom page for scheduling
        post :create_date   # 👈 form submission for new dates
      end
    end

    resources :session_types, except: [:show]
    resources :scheduled_sessions do
      resources :time_slots, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
