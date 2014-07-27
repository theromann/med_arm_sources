module VhodSystemRoles
  module UsersControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :update, :system_roles
      end
    end
  end
  module InstanceMethods
    def update_with_system_roles
      @user.system_roles.clear
      update_without_system_roles
      if params[:user][:system_roles]
        params[:user][:system_roles].each do |role_name|
          @user.system_roles << SystemRole.find_by_name(role_name)
        end
      end
    end
  end
end
