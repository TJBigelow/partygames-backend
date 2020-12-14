Rails.application.routes.draw do
  resources :prompts
  resources :matchups
  resources :rounds
  resources :games
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
