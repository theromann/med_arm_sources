Redmine::Plugin.register :arm_cleaning do
  name 'Arm Cleaning plugin'
  author 'Arm'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :home
  menu.delete :my_page
  menu.delete :help
end
