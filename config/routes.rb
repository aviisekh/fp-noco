Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#index"
  get "/upload_fp_csvs", to:"dashboard#upload_fp_csvs"
  post "/submit_fp_csvs", to:"dashboard#submit_fp_csvs"
  
end
