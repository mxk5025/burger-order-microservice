Rails.application.routes.draw do
  root 'orders#show'
  post 'orders/receive_completed'
  post 'orders', to: 'orders#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
