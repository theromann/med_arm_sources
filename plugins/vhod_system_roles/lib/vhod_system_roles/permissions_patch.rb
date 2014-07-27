class Redmine::AccessControl::Permission
  attr_reader :system

  def initialize(name, hash, options)
    @name = name
    @actions = []
    @system = options[:system]
    @public = options[:public] || false
    @public = false if @system
    @require = options[:require]
    @read = options[:read] || false
    @project_module = options[:project_module]
    @project_module = :system_permissions if @system
    hash.each do |controller, actions|
      if actions.is_a? Array
        @actions << actions.collect {|action| "#{controller}/#{action}"}
      else
        @actions << "#{controller}/#{actions}"
      end
    end
    @actions.flatten!
  end
end