class AdvertisersController < ApplicationController
  def show
    @advertiser = Advertiser.find(params[:id])
    product_count = Rails.cache.fetch("all_advertiser_#{@advertiser.id}_products_count") { @advertiser.products.size  }
    @products = @advertiser.products.includes(:category, :advertiser).page_with_cached_total_count(params[:page], product_count)
  end

  def index
  end
end
