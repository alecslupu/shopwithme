class ProductsController < ApplicationController
  def visit
    product = Product.find(params[:id])
    redirect_to product.aw_deep_link
  end

  def show 
    @product = Product.find(params[:id])
  end 
end
