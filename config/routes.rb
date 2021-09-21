Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :init
      resources :movies
      resources :actors
    end
  end
end
