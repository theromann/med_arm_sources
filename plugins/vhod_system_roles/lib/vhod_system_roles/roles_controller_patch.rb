module VhodSystemRoles
  module RolesControllerPatch

    class RoleSelectError < Exception
    end

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        def index
          respond_to do |format|
            format.html {
              @role_pages, @roles = paginate (Role.sorted), :per_page => 25
              render :action => "index", :layout => false if request.xhr?
            }
            format.api {
              @roles = Role.givable.all + SystemRole.givable.all
            }
          end
        end

        def new
          # Prefills the form with 'Non member' role permissions by default
          @role = Role.new(params[:role] || {:permissions => Role.non_member.permissions})
          if params[:copy].present? && @copy_from = Role.find_by_id(params[:copy])
            @role.copy_from(@copy_from)
          end
          @roles = Role.sorted.all + SystemRole.sorted.all
        end

        def create
          role_class = params[:role][:type].constantize

          @role = role_class.new(params[:role])

          if @role.type.eql?("SystemRole")
            @role.groups = params[:groups].present? ? Group.find(params[:groups]) : []
          end

          raise RoleSelectError unless (@role.is_a?(Role) || @role.is_a?(SystemRole))

          if request.post? && @role.save
            # workflow copy
            if !params[:copy_workflow_from].blank? && (copy_from = role_class.find_by_id(params[:copy_workflow_from]))
              @role.workflow_rules.copy(copy_from)
            end
            flash[:notice] = l(:notice_successful_create)
            redirect_to roles_path
          else
            @roles = Role.sorted.all + SystemRole.sorted.all
            render :action => 'new'
          end
        end

        def update
          @role.type = params[:role][:type]
          if request.put? and @role.update_attributes(params[:role])
            if @role.type.eql?("SystemRole")
              @role = @role.reload
              @role.groups = params[:groups].present? ? Group.find(params[:groups]) : []
            end
            flash[:notice] = l(:notice_successful_update)
            redirect_to roles_path
          else
            render :action => 'edit'
          end
        end

        def permissions
          @roles = Role.sorted.all  + SystemRole.sorted.all
          @permissions = Redmine::AccessControl.permissions.select { |p| !p.public? }
          if request.post?
            @roles.each do |role|
              role.permissions = params[:permissions][role.id.to_s]
              role.save
            end
            flash[:notice] = l(:notice_successful_update)
            redirect_to roles_path
          end
        end

        def system_permissions
          @role = Role.find_by_name(params[:name]) || SystemRole.new
          @permissions = Redmine::AccessControl.permissions.select(&:system)
          render :partial => 'system_permissions', :locals => { :role => @role, :permissions => @permissions }
        end
      end
    end
  end
end