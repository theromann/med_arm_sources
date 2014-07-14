Redmine::Plugin.register :arm_common do
  name 'Arm Common plugin'
  author 'Arm Co'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

Dir.glob File.expand_path(File.join(__FILE__, '..')) do |dir|
  require "#{dir}/app/inputs/assigned_editor_select2_input"
  require "#{dir}/app/inputs/products_select2_input"
  require "#{dir}/app/inputs/product_select2_input"
  require "#{dir}/app/inputs/unicode_value_check_boxes_input"
end


Rails.configuration.to_prepare do
  %w(application_helper ).each do |resource|
    plugin_name = 'arm_common'
    resource_patch = [plugin_name, [resource, 'patch'].join('_')].join('/')

    require_dependency resource # Можно спрятать внутрь патчей
    #require resource_patch # Если директория подключения совпадает с модулем, то нет необходимости явно указывать require

    resource_constant, resource_patch_constant = [resource, resource_patch].map(&:camelize).map(&:constantize)

    resource_constant.send(:include, resource_patch_constant) unless resource_constant.included_modules.include? resource_patch_constant
  end
end