BadHair::Application.routes.draw do
  root :to => 'pages#index'
  post '/results' => 'pages#results'
  get '/contact' => 'pages#contact'
  get "/login" => "session#new"
  post "/login" => "session#create"
  delete "/login" => "session#destroy"
  patch "/hairstyles/:id/edit" => "hairstyles#edit"
  resources :hairstyles, :users
end
