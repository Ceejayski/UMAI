Rails.application.routes.draw do
  get 'feedbacks', to: 'feedbacks#index'
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => "/sidekiq"
  get 'ips', to: 'ips#index'
  post 'login', to: 'authentications#authenticate'
  post 'sign_up', to: 'registrations#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts do
    resources :ratings, only: %i[index create]
  end
end
