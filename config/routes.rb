# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'welcome#index'

    get '/auth/:provider/callback', to: 'auth#callback', as: :callback_auth, via: :all
    post '/auth/:provider', to: 'auth#request', as: :auth_request
    delete '/auth/logout', to: 'auth#logout', as: :auth_logout

    post '/api/checks', to: 'checks#checks', as: :api_checks

    resources :repositories, only: %i[index show new create] do
      scope module: :repositories do
        resources :checks, only: %i[create show]
      end
    end
  end
end
