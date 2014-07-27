require 'redmine'
require  File.dirname(__FILE__)  + '/lib/vhod_system_roles/permissions_patch'
require  File.dirname(__FILE__)  + '/lib/vhod_system_roles/hooks'

ActionDispatch::Callbacks.to_prepare do

  require_dependency 'user'
  unless User.included_modules.include?(VhodSystemRoles::UserPatch)
    User.send(:include, VhodSystemRoles::UserPatch)
  end

  require_dependency 'group'
  unless Group.included_modules.include?(VhodSystemRoles::GroupPatch)
    Group.send(:include, VhodSystemRoles::GroupPatch)
  end

  require_dependency 'role'
  unless Role.included_modules.include?(VhodSystemRoles::RolePatch)
    Role.send(:include, VhodSystemRoles::RolePatch)
  end

  require_dependency 'roles_controller'
  unless RolesController.included_modules.include?(VhodSystemRoles::RolesControllerPatch)
    RolesController.send(:include, VhodSystemRoles::RolesControllerPatch)
  end

  require_dependency 'users_controller'
  unless UsersController.included_modules.include?(VhodSystemRoles::UsersControllerPatch)
    UsersController.send(:include, VhodSystemRoles::UsersControllerPatch)
  end

end

Redmine::Plugin.register :vhod_system_roles do
  name 'Vhod Svn plugin'
  author 'Elins'
  version '0.0.1'
  description 'This is a plugin system roles integration'
end
