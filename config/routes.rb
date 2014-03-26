BadHair::Application.routes.draw do
  root :to => 'pages#index'
  post '/results' => 'pages#results'
  get '/contact' => 'pages#contact'
  get "/login" => "session#new"
  post "/login" => "session#create"
  delete "/login" => "session#destroy"
  patch "/hairstyles/:id/edit" => "hairstyles#edit"
  get "/users/custom_results/:hairstyle" => "users#custom_results", as: "custom"
  resources :hairstyles, :users
end
