Rails.application.routes.draw do
  use_doorkeeper
  use_doorkeeper_openid_connect
  resources :oauth2_applications, only: %i[update create]
  devise_for :users, controllers: { sessions: 'user/sessions',
                                    passwords: 'user/passwords',
                                    confirmations: 'user/confirmations',
                                    unlocks: 'user/unlocks',
                                    registrations: 'user/registrations' }
  resources :employees, only: :index
  resource :setting, only: :update do
    member do
      get :profile
    end
  end

  get '/me' => 'doorkeeper#me'
  get '/profiles' => 'doorkeeper#profiles'
  # To make turbolink still works in client app
  match '/oauth/authorize' => 'doorkeeper#options_authorize', via: :options

  root to: 'home#index'
end
