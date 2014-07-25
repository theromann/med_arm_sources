class ProductDepreciationsController < ApplicationController
  unloadable

  before_filter :new_product_depreciation, only: [:new, :create, :cancel_one]
  before_filter :find_product_depreciation, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show

  end

  def new
  end

  def create
    return unless update_product_movement_from_params
    respond_to do |format|
      if @depreciation.save
        format.html { redirect_to @depreciation,notice:l(:notice_successful_create)}
        format.json { render json: @depreciation, status: :created, location: @depreciation }
      else
        format.html { render action: 'new' }
        format.json { render json: @depreciation.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def cancel_one
  end



  private

  def new_product_depreciation
    @depreciation = ProductDepreciation.new(params[:product_depreciation])
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
end
