class AdvertisersController < ApplicationController
  before_filter :fix_brand_advertiser, :only => [ :show ]


  def show
    product_count = Rails.cache.fetch("all_advertiser_#{@advertiser.id}_products_count",:expires_in => 6.hours) { @advertiser.products.size  }
    @products = @advertiser.products.includes(:category, :advertiser).page_with_cached_total_count(params[:page], product_count)
  end

  def index
    @advertisers = Advertiser.alphabetically.with_products.page(params[:page])
  end

  private 
  def fix_brand_advertiser
    @advertiser = Advertiser.where(:slug => params[:id]).first
    if @advertiser.nil?
      brand = Brand.where(:slug => params[:id]).first
      redirect_to brand_path(brand), :status => :moved_permanently unless brand.nil?
    end
  end 
end
