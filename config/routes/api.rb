namespace :api do
  resources :users do
    post '/', to: 'users#create'
    get 'info', to: 'users#show' 
  end
end

scope :api do
  # this is going to add the /oauth/* routes.
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
end