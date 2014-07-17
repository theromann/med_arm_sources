class ProductStorageRelationsController < ApplicationController
  before_filter :find_product, :authorize, :only => [:index, :create]
  before_filter :find_relation, :except => [:index, :create]

  accept_api_auth :index, :show, :create, :destroy

  def index
    @relations = @product.product_storage_relations

    respond_to do |format|
      format.html { render :nothing => true }
      format.api
    end
  end

  def show
    respond_to do |format|
      format.html { render :nothing => true }
      format.api
    end
  end

  def create
    @relation = ProductStorageRelation.new(params[:relation])
    @relation.product = @product
    if params[:relation] && m = params[:relation][:product_storage_id].to_s.strip.match(/^#?(\d+)$/)
      @relation.product_storage = ProductStorage.find_by_id(m[1].to_i)
    end
    saved = @relation.save

    respond_to do |format|
      format.html { redirect_to product_path(@product) }
      format.js {
        @relations = @product.reload.relations.select {|r| r.product_storage }
      }
      format.api {
        if saved
          render :action => 'show', :status => :created, :location => relation_url(@relation)
        else
          render_validation_errors(@relation)
        end
      }
    end
  end

  def destroy
    @relation.destroy

    respond_to do |format|
      format.html { redirect_to product_path(@relation.product) }
      format.js
      format.api  { render_api_ok }
    end
  end

  private
  def find_qa_action
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_relation
    @relation = ProductStorageRelation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
