# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :products do
  member do
    get 'receipt_one'
  end
  collection do
    get 'get_product_list_in_storage'
    get 'get_max_product_count'
  end
end
resources :product_storages

resources :product_queries, only: [:new, :create, :destroy]

resources :product_storage_relations

resources :product_movements

resources :product_depreciations do
  collection do
    get 'cancel_one'
  end
end

resources :product_storages_groups
resources :products_groups



