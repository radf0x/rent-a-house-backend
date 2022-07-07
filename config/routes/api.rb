namespace :api do
  resources :users do
    post '/', to: 'users#create'
    get 'info', to: 'users#show' 
  end

  get 'rentals', to: 'rentals#index'
  get 'rentals/:id', to: 'rentals#show'
  post 'rentals', to: 'rentals#create'
  patch 'rentals/:id', to: 'rentals#update'
  delete 'rentals/:id', to: 'rentals#delete'
  post 'rentals/:id/like', to: 'rentals#like'
  delete 'rentals/:id/like', to: 'rentals#unlike'
end

scope :api do
  # this is going to add the /oauth/* routes.
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
end