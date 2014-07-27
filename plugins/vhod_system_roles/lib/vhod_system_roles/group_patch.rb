module VhodSystemRoles
  module GroupPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        has_and_belongs_to_many :system_roles
      end
    end
  end

end