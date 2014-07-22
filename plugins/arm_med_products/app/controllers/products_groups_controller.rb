class ProductsGroupsController < ApplicationController
  unloadable

  def new
    @products_group = ProductsGroup.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @products_group = ProductsGroup.find(params[:id])
  end

  def create
    @products_group = ProductsGroup.new(params[:enumeration])
    respond_to do |format|
      if @products_group.save
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=products', notice:l(:notice_successful_create) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @products_group = ProductsGroup.find(params[:id])
    respond_to do |format|
      if @products_group.update_attributes(params[:enumeration])
        format.html { redirect_to '/settings/plugin/arm_med_products?tab=products', notice:l(:notice_successful_create) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @products_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @products_group = ProductsGroup.find(params[:id])
    @products_group.destroy
    respond_to do |format|
      format.html { redirect_to '/settings/plugin/arm_med_products?tab=products' }
      format.json { head :no_content }
    end
  end

  def index
    @products_group = ProductsGroup.all
  end



end
