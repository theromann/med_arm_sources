# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :products

resources :product_queries, only: [:new, :create, :destroy]