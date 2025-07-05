require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    namespace :users do
      post '/register', action: :create
      post :login
      get :data
    end

    resources :password_resets, only: [:create, :update] do
      member do
        get :validate_token
      end
    end

    namespace :questions do
      post :create
    end

    namespace :simulates do
      post :answer
      get :questions
      get 'questions/:id', action: :show, as: :question
      get :results
      get :retry_responses
    end
  end

  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
