Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'little_urls#new'
  resources :little_urls, only: %i[create show edit update destroy] do
    delete :destroy_all, on: :collection
  end
  get '/:id', to: 'redirects#show', as: :redirect
end
