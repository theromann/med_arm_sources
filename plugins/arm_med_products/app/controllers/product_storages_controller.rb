class ProductStoragesController < ApplicationController
  unloadable

  # before_filter :find_product_storage, :only => [:create, :edit, :update]

  def new
    @product_storage = ProductStorage.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_storage }
    end
  end

  def edit
    @product_storage = ProductStorage.find(params[:id])
  end

  def create
    @product_storage = ProductStorage.new(params[:product_storage])
    respond_to do |format|
      if @product_storage.save
        #TODO: сделать всплывающее окно при создании нового потребления
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages', notice:l(:notice_successful_create) }
        # format.html { redirect_to tabs_contact_path(@contact.id, :consumptions) }
        format.json { render json: @product_storage, status: :created, location: @product_storage }
      else
        format.html { render action: 'new' }
        format.json { render json: @product_storage.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product_storage = ProductStorage.find(params[:id])
    respond_to do |format|
      if @product_storage.update_attributes(params[:product_storage])
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages', notice:l(:notice_successful_create) }
        # format.html { redirect_to tabs_contact_path(@contact.id, :consumptions) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_storage.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_storage = ProductStorage.find(params[:id])
    @product_storage.destroy
    respond_to do |format|
      format.html { redirect_to '/settings/plugin/arm_med_products?tab=product_storages' }
      format.json { head :no_content }
    end
  end

  def index
    @product_storages = ProductStorage.all
  end



end
