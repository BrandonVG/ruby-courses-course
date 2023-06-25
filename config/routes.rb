Rails.application.routes.draw do

  devise_for :users

  root 'static_pages#landing_page'
  get 'privacy-policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'static_pages#activity'
  get 'analytics', to: 'static_pages#analytics'

  resources :enrollments do
    get :my_students, on: :collection
  end

  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end

  resources :users, only: [:index, :edit, :show, :update]
  
  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end

end
