BeaverTail::Application.routes.draw do |map|
  match '/logout' => 'sessions#destroy', :as => :logout
  get '/login' => 'sessions#new', :as => :login
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  
  resource :session
  
  resources :hidden_actions do
    delete 'destroy', :on => :collection
  end
  
  match '/options' => 'application#options', :as => :logout
  resources :logs do
    get 'pull', :on => :member
  end
  resources :users
  resource :user
  root :to => 'sessions#new'
  SprocketsApplication.routes(map)
end
