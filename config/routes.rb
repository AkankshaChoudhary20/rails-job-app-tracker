Rails.application.routes.draw do
  root "dashboard#index"

  get "signup", to: "registrations#new"
  resource :registration, only: %i[create]

  get "login", to: "sessions#new"
  resource :session, only: %i[create destroy]

  resources :applications do
    member do
      # Dedicated endpoint for the inline Turbo Stream status change,
      # kept separate from the general #update so the row can re-render
      # itself without needing a full form submit.
      patch :update_status
    end
  end

  # Health check endpoint for load balancers / uptime monitors.
  get "up" => "rails/health#show", as: :rails_health_check
end
