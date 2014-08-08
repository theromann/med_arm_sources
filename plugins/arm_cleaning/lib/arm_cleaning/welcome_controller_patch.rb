module ArmCleaning
  module WelcomeControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        def index
          @news = News.latest User.current
          @projects = Project.latest User.current
          if User.current.logged?
            redirect_to products_path
          else
            redirect_to signin_path
          end
        end
      end
    end

    module InstanceMethods

    end
  end
end