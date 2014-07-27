module VhodSystemRoles
  class Hooks < Redmine::Hook::ViewListener
    def view_users_form(context={ })
      # the controller parameter is part of the current params object
      # This will render the partial into a string and return it.
      context[:controller].send(:render_to_string, {
          :partial => 'hooks/system_roles',
          :locals => context
      })

      # Instead of the above statement, you could return any string generated
      # by your code. That string will be included into the view
    end

  end
end