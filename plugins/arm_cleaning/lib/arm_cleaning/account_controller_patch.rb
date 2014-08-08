module ArmCleaning
  module AccountControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        def successful_authentication(user)
          logger.info "Successful authentication for '#{user.login}' from #{request.remote_ip} at #{Time.now.utc}"
          # Valid user
          self.logged_user = user
          # generate a key and set cookie if autologin
          if params[:autologin] && Setting.autologin?
            set_autologin_cookie(user)
          end
          call_hook(:controller_account_success_authentication_after, {:user => user })
          redirect_back_or_default products_path
        end
      end
    end

    module InstanceMethods

    end
  end
end