Rails.application.routes.draw do
  root "articles#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # get "/articles", to: "articles#index" #get the /articles with the action index in the articles controller
  # get "/articles/:id", to: "articles#show" #get the /articles/:id with the action show in the articles controller
  resources:articles do
    resources:comments
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
