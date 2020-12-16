Rails.application.routes.draw do
  resources :bot_responses
  resources :players
  resources :prompts
  resources :matchups
  resources :rounds
  resources :games
  post '/games/:id', to: 'games#start'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
end
