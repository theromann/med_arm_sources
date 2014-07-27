get  'roles', :to => 'roles#index', :as => 'system_roles'
put  'roles/:id', :to => 'roles#update', :as => 'system_role'

get 'system_permissions',       :to => 'roles#system_permissions', :as => "system_permissions"