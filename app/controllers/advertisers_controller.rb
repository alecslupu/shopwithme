class AdvertisersController < ApplicationController
  caches_page :index, :show

  def show
    @advertiser = Advertiser.find(params[:id])
    product_count = Rails.cache.fetch("all_advertiser_#{@advertiser.id}_products_count",:expires_in => 6.hours) { @advertiser.products.size  }
    @products = @advertiser.products.includes(:category, :advertiser).page_with_cached_total_count(params[:page], product_count)
  end

  def index
    @advertisers = Advertiser.alphabetically.with_products.page(params[:page])
  end

end
