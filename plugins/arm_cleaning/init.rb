Redmine::Plugin.register :arm_cleaning do
  name 'Arm Cleaning plugin'
  author 'Arm'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :home
  menu.delete :my_page
  menu.delete :help
end

Redmine::MenuManager.map :customer_menu do |menu|
  # menu.push :projects, {:controller => 'admin', :action => 'projects'}, :caption => :label_project_plural
  # menu.push :users, {:controller => 'users'}, :caption => :label_user_plural
  # menu.push :groups, {:controller => 'groups'}, :caption => :label_group_plural
  # menu.push :roles, {:controller => 'roles'}, :caption => :label_role_and_permissions
  # menu.push :trackers, {:controller => 'trackers'}, :caption => :label_tracker_plural
  # menu.push :issue_statuses, {:controller => 'issue_statuses'}, :caption => :label_issue_status_plural,
  #           :html => {:class => 'issue_statuses'}
  # menu.push :workflows, {:controller => 'workflows', :action => 'edit'}, :caption => :label_workflow
  # menu.push :custom_fields, {:controller => 'custom_fields'},  :caption => :label_custom_field_plural,
  #           :html => {:class => 'custom_fields'}
  # menu.push :enumerations, {:controller => 'enumerations'}
  # menu.push :settings, {:controller => 'settings'}
  # menu.push :ldap_authentication, {:controller => 'auth_sources', :action => 'index'},
  #           :html => {:class => 'server_authentication'}
  # menu.push :plugins, {:controller => 'admin', :action => 'plugins'}, :last => true
  # menu.push :info, {:controller => 'admin', :action => 'info'}, :caption => :label_information_plural, :last => true
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :projects
end

Rails.configuration.to_prepare do
  %w(account_controller welcome_controller ).each do |resource|
    plugin_name = 'arm_cleaning'
    resource_patch = [plugin_name, [resource, 'patch'].join('_')].join('/')

    require_dependency resource # Можно спрятать внутрь патчей
    #require resource_patch # Если директория подключения совпадает с модулем, то нет необходимости явно указывать require

    resource_constant, resource_patch_constant = [resource, resource_patch].map(&:camelize).map(&:constantize)

    resource_constant.send(:include, resource_patch_constant) unless resource_constant.included_modules.include? resource_patch_constant
  end
end

