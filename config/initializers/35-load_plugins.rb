##Redmine::Plugin.load
require File.dirname(__FILE__) + '/../load_plugins'
unless Redmine::Configuration['mirror_plugins_assets_on_startup'] == false
  Redmine::Plugin.mirror_assets
end
