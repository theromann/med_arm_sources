Redmine::Plugin.register :arm_med_products do
  name 'Arm Med Products plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  requires_redmine_plugin :vhod_system_roles, version_or_higher: '0.0.1'

  settings( default: {
      product_list_default_columns: [
          'name',
          'group',
          'count',
          'status'
      ]
  }, partial: 'settings/products')

  menu :top_menu, :products, {controller: 'products', action: 'index'}, :caption => :label_products

  menu :admin_menu, :products, {:controller => 'settings', :action => 'plugin', :id => "arm_med_products"}, :caption => :products_settings_title
  menu :customer_menu, :products, {:controller => 'settings', :action => 'plugin', :id => "arm_med_products"}, :caption => :products_settings_title

  permission :show_products, {products:  [:index]}, system: true
  permission :create_product, {products:  [:new, :create]}, system: true
  permission :receipt_products, {products:  [:receipt_one]}, system: true
  permission :destroy_product, {products: [:destroy]}, system: true
  permission :create_product_movements, {product_movements: [:new, :create]}, system: true
  permission :create_product_depreciation, {product_depreciations: [:new, :create]}, system: true



end

Dir.glob File.expand_path(File.join(__FILE__, '../..')) do |dir|
  require "#{dir}/arm_common/app/inputs/products_select2_input"
  require "#{dir}/arm_common/app/inputs/date_with_calendar_input"
end

Rails.configuration.to_prepare do
  %w(queries_helper ).each do |resource|
    plugin_name = 'arm_med_products'
    resource_patch = [plugin_name, [resource, 'patch'].join('_')].join('/')

    require_dependency resource # Можно спрятать внутрь патчей
    #require resource_patch # Если директория подключения совпадает с модулем, то нет необходимости явно указывать require

    resource_constant, resource_patch_constant = [resource, resource_patch].map(&:camelize).map(&:constantize)

    resource_constant.send(:include, resource_patch_constant) unless resource_constant.included_modules.include? resource_patch_constant
  end
end


require_dependency 'products_group'
require_dependency 'product_storages_group'
require_dependency 'product_cancellations_reason'