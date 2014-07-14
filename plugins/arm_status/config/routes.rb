RedmineApp::Application.routes.draw do
  resources :arm_statuses
  resources :arm_trackers
  match 'arm_workflows', controller: :arm_workflows, action: :index, via: :get
  match 'arm_workflows/edit', controller: :arm_workflows, action: :edit, :via => [:get, :post]
  match 'arm_workflows/permissions', controller: :arm_workflows, action: :permissions, :via => [:get, :post]

end