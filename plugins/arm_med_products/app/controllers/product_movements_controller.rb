class ProductMovementsController < ApplicationController
  unloadable

  before_filter :new_product_movement, only: [:new, :create]
  before_filter :find_product_movement, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show

  end


  def create
    return unless update_product_movement_from_params
    respond_to do |format|
      if @movement.save
        format.html { redirect_to products_path ,notice:l(:notice_successful_create)}
        format.json { render json: @movement, status: :created, location: @movement }
      else
        format.html { render action: 'new' }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end


  private

  def new_product_movement
    @movement = ProductMovement.new(params[:product_movement])
  end


  def update_product_movement_from_params
    # movement_attributes = params[:product_movement]
    # @movement.safe_attributes = movement_attributes
    true
  end

  def find_product_movement
    @movement = ProductMovement.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
