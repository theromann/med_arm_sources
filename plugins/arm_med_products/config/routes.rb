# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :products do

end
resources :product_storages

resources :product_queries, only: [:new, :create, :destroy]

resources :product_storage_relations

resources :product_movements
resources :product_storages_groups
resources :products_groups



