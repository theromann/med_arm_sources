module VhodSystemRoles
  module RolePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
      base.class_eval do
        unloadable
        alias_method_chain :setable_permissions, :system_roles
      end
    end
  end

  module InstanceMethods
    def setable_permissions_with_system_roles
      setable_permissions = setable_permissions_without_system_roles
      setable_permissions.delete_if{ |permission| permission.system }
    end
  end

  module ClassMethods
    def find_all_givable_without_system_roles
      Role.find_all_givable.reject { |r| r.type == 'SystemRole' }
    end
  end
end