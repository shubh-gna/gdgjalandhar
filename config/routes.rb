Rails.application.routes.draw do
  resources :sample_submissions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sample_submissions#new"
end
