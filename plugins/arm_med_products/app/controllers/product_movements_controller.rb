class ProductMovementsController < ApplicationController
  unloadable

  def new
    @movement = ProductMovement.new
  end

  def index
  end

end
