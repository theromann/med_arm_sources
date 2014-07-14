class ArmStatusesController < ApplicationController
  layout 'admin'

  before_filter :require_admin, :except => :index
  before_filter :require_admin_or_api_request, :only => :index
  before_filter :build_new_arm_status, :only => [:new, :create]
  before_filter :find_arm_status, :only => [:edit, :update, :destroy]
  accept_api_auth :index

  helper :custom_fields

  def index
    respond_to do |format|
      format.html
      format.api {
        @klass = ArmStatus.get_subclass(params[:type])
        if @klass
          @arm_status = @klass.shared.sorted.all
        else
          render_404
        end
      }
    end
  end

  def new
  end

  def create
    if request.post? && @arm_status.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to arm_statuses_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if request.put? && @arm_status.update_attributes(params[:arm_status])
      flash[:notice] = l(:notice_successful_update)
      redirect_to arm_statuses_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    if !@arm_status.in_use?
      # No associated objects
      @arm_status.destroy
      redirect_to arm_statuses_path
      return
    elsif params[:reassign_to_id]
      if reassign_to = @arm_status.class.find_by_id(params[:reassign_to_id])
        @arm_status.destroy(reassign_to)
        redirect_to arm_statuses_path
        return
      end
    end
    @arm_statuses = @arm_status.class.all - [@arm_status]
  end

  private

  def build_new_arm_status
    class_name = params[:arm_status] && params[:arm_status][:type] || params[:type]
    @arm_status = ArmStatus.new_subclass_instance(class_name, params[:arm_status])
    if @arm_status.nil?
      render_404
    end
  end

  def find_arm_status
    @arm_status = ArmStatus.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end