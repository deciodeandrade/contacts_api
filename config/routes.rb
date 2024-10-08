Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'users/registrations'
  }
  
  get "home" => "home#index"

  resources :contacts

  resources :addresses, only: [] do
    collection do
      get 'search_by_cep'
      get 'suggestions'
    end
  end
end
