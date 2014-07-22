class ProductStoragesGroupsController < ApplicationController
  unloadable

  # before_filter :find_product_storage, :only => [:create, :edit, :update]

  def new
    @product_storages_group = ProductStoragesGroup.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_storages_group }
    end
  end

  def edit
    @product_storages_group = ProductStoragesGroup.find(params[:id])
  end

  def create
    @product_storages_group = ProductStoragesGroup.new(params[:enumeration])
    respond_to do |format|
      if @product_storages_group.save
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages', notice:l(:notice_successful_create) }
        # format.html { redirect_to tabs_contact_path(@contact.id, :consumptions) }
        format.json { render json: @product_storages_group, status: :created, location: @product_storages_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @product_storages_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product_storages_group = ProductStoragesGroup.find(params[:id])
    respond_to do |format|
      if @product_storages_group.update_attributes(params[:enumeration])
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages', notice:l(:notice_successful_create) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_storages_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_storages_group = ProductStoragesGroup.find(params[:id])
    @product_storages_group.destroy
    respond_to do |format|
      format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages' }
      format.json { head :no_content }
    end
  end

  def index
    @product_storages_group = ProductStoragesGroup.all
  end



end
