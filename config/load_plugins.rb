# Скрипт для правильности порядка загрузки плагинов.
# т.к Redmine::Plugin.load (см redmine/plugin.rb и initializer 30-redmine.rb) загружает
# плагины в алфавитном порядке, возникают некоторые проблемы с зависимостями плагинов
# Этот скрипт позволяет изменить порядок загрузки плагинов, добавляя в начало те, которые указаны
# в списке plugins.
# Затем загружает все остальные плагины в алфавитном порядке

plugins =  [
  # TODO: вставить название плагина мед-склад (было "redmine_contacts"),
  "arm_common",
  "arm_status",
  "vhod_system_roles"
  ]

def load_specific_plugin(name)
  # Код взят из Redmine::Plugin.load
  directory = Rails.root.to_s + "/plugins/" + name
  if File.directory?(directory)
    lib = File.join(directory, "lib")
    if File.directory?(lib)
      $:.unshift lib
      ActiveSupport::Dependencies.autoload_paths += [lib]
    end
    initializer = File.join(directory, "init.rb")
    if File.file?(initializer)
      require initializer
    end
  end
end

plugins.each do |name|
  load_specific_plugin(name)
end
Redmine::Plugin.load
