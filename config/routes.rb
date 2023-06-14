Rails.application.routes.draw do
  devise_for :users
  resources :courses
  resources :users, only: [:index, :edit, :show, :update]
  root 'static_pages#landing_page'
  get 'privacy-policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'static_pages#activity'
end
