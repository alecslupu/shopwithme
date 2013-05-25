class ProductsController < ApplicationController

  def index 
    @products = Product.page params[:page]
  end

  def show
    @product = Product.find(params[:id])
  end 

  def visit
    product = Product.find(params[:id])
    redirect_to product.aw_deep_link
  end

end
