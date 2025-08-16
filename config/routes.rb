Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'little_urls#new'
  resources :little_urls, only: %i[create show edit update]
  resources :redirects, only: %i[show]
  get '/:token/info', to: 'little_urls#info', as: :little_url_info
end
