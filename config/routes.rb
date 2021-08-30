Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/create'
  get 'posts/update'
  get 'posts/show'
  get 'posts/destroy'
  post 'login', to: 'authentications#authenticate'
  post 'sign_up', to: 'registrations#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
