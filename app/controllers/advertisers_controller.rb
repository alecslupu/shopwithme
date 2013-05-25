class AdvertisersController < ApplicationController
  def show
    @advertiser = Advertiser.find(params[:id])
    @products = @advertiser.products.includes(:category).page params[:page]
  end

  def index
  end
end
