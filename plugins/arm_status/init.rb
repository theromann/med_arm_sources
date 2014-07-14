Redmine::Plugin.register :arm_status do
  name 'Arm Status plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :arm_status_menu, '/arm_statuses', caption: :arm_status_menu, after: :enumerations
  # menu.push :arm_tracker_menu, '/arm_trackers', caption: :arm_tracker_menu, after: :trackers
  # menu.push :arm_workflow_menu, '/arm_workflows/edit', caption: :arm_workflow_menu, after: :workflows

end


Rails.configuration.to_prepare do
  # require_dependency 'arm_status'
  # require_dependency 'contact_status'
  # require_dependency 'contact_person_status'
  # require_dependency 'arm_status/contact_patch'
  # require_dependency 'arm_status/contacts_helper_patch'
  # require_dependency 'arm_status/contacts_controller_patch'
  # [
  #     [Contact, ArmStatusPlugin::ContactPatch],
  #     [ContactsHelper, ArmStatusPlugin::ContactsHelperPatch],
  #     [ContactsController, ArmStatusPlugin::ContactsControllerPatch]
  # ].each do |cl, patch|
  #   cl.send(:include, patch) unless cl.included_modules.include? patch
  # end
end