Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'users/registrations'
  }
  
  get "home" => "home#index"

  resources :contacts

  get 'addresses/search_by_cep', to: 'addresses#search_by_cep'
end
