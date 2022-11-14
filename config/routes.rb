Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "scenarios#index"
  get "/upload_fp_csvs", to:"dashboard#upload_fp_csvs"
  post "/submit_fp_csvs", to:"dashboard#submit_fp_csvs"

  resources :scenarios
  resources :dashboard, only: %i[index]

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  
end
