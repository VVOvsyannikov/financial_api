Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ] do
        collection do
          get :balance
          post :deposit
          post :withdraw
        end
      end

      resources :transfers, only: [ :create ]
    end
  end
end
