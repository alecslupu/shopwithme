class BrandsController < ApplicationController
  def show
    @brand = Brand.find(params[:id])
    @products = @brand.products.page params[:page]
  end

  def index
  end
end
