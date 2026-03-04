Rails.application.routes.draw do
  root "creators#index"

  resources :creators, only: [ :index, :show ] do
    resources :contents, except: [ :index, :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
