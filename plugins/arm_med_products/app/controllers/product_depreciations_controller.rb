class ProductDepreciationsController < ApplicationController
  unloadable
  before_filter :authorize

  before_filter :new_product_depreciation, only: [:new]
  before_filter :find_product_depreciation, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show

  end

  def new
  end

  def create
    @depreciation = ProductDepreciation.new(params[:product_depreciation])
    return unless update_product_movement_from_params
    if @depreciation.save
      respond_to do |format|
        format.html {       redirect_to products_path,notice:l(:notice_successful_create)        }
        format.js
      end
    else
      redirect_to products_path
    end
  end

  private

  def new_product_depreciation
    @depreciation = ProductDepreciation.new(params[:product_depreciation])
    @depreciation.product_storage_relations.build
  end


  def update_product_movement_from_params

    # movement_attributes = params[:product_movement]
    # @movement.safe_attributes = movement_attributes
    true
  end

  def find_product_depreciation
    @depreciation = ProductDepreciation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = false)
    allowed = User.current.allowed_to?({controller: ctrl, action: action}, :system)
    if allowed
      true
    else
      render_403
    end
  end
end
