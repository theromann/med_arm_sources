module VhodSystemRoles
  module UserPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        has_and_belongs_to_many :system_roles, :join_table => :user_system_roles
        alias_method_chain :allowed_to?, :system_roles
        alias_method_chain :system_roles, :active_directory
      end
    end
  end

  module InstanceMethods

    def system_roles_with_active_directory
      if(auth_source.is_a? AuthSourceLdap)
        groups.map(&:system_roles).flatten.uniq
      else
        system_roles_without_active_directory
      end
    end

    def allowed_to_with_system_roles?(action, context, options={}, &block)
      return false unless context.allows_to?(action) if context.is_a?(Project)
      return true if admin?
      if context.eql?(:system)
        system_roles.any? {|role| role.allowed_to?(action) }
      else
        allowed_to_without_system_roles?(action, context, options, &block)
      end
    end

  end
end