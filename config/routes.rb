Rails.application.routes.draw do
  resources :votes
  resources :bot_responses
  resources :players
  resources :prompts
  resources :matchups
  resources :rounds
  resources :games
  post '/games/:id', to: 'games#start'
  post '/watch/:code', to: 'games#watch'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
end
