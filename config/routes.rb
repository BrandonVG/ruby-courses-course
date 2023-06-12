Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'privacy-policy', to: 'static_pages#privacy_policy'
end
