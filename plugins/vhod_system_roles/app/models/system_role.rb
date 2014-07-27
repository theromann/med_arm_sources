class SystemRole < Role
  unloadable
  reflections.reject!{|key, _| key == :members }

  has_and_belongs_to_many :groups

  def setable_permissions
    setable_permissions = super
    setable_permissions += Redmine::AccessControl.permissions.select{|p| p.system }
    setable_permissions
  end
end