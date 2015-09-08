Rails.application.routes.draw do
  root to: "welcome#show"

  resources :insamlings, only: [:new, :show, :create, :update] do
    resources :needs, only: [:create, :destroy]
    resources :admins, only: [:show]
  end
end
