Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'static_pages#landing_page'
  get 'privacy-policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'static_pages#activity'
  get 'analytics', to: 'static_pages#analytics'
  get 'charts/users_per_day', to: 'charts#users_per_day'
  get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  get 'charts/course_popularity', to: 'charts#course_popularity'
end
