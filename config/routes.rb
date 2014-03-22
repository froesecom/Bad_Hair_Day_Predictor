BadHair::Application.routes.draw do
  root :to => 'pages#index'
  post '/results' => 'pages#results'
  get '/contact' => 'pages#contact'
  resources :hairstyles, :users
end
