class BrandsController < ApplicationController
  before_filter :ensure_search_term_presence, :only => [ :search ]

  before_filter :fix_missing_brands , :only => :show

  def show
    @brand = Brand.find(params[:id])
    product_count = Rails.cache.fetch("all_brand_#{@brand.id}_products_count",:expires_in => 6.hours) { @brand.products.size }
    @products = @brand.products.page_with_cached_total_count(params[:page], product_count)
  end

  # def index
  #   if params[:chr].nil?
  #     @brands = Brand.ordered.page params[:page]
  #   elsif ("a".."z").to_a.include?(params[:chr].downcase)
  #     @brands = Brand.ordered.where("LOWER(name) LIKE ? ", "#{params[:chr].downcase}%").page params[:page]
  #   end
    
  # end
  def index
    @brands = Brand.alphabetically.with_products.page(params[:page])
  end

  def search 
    @brands = Brand.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
  end 

  private 

  def ensure_search_term_presence
    if params[:search].blank?
      redirect_to(brands_path) and return 
    end 
  end 
  
  def fix_missing_brands
    redirect_to_brand(params[:id].gsub!('-amp', '')) if params[:id].include?('-amp')
    redirect_to_brand(params[:id].gsub!('-quot', '')) if params[:id].include?('-quot')
    redirect_to_brand(params[:id].gsub!('-39', '')) if params[:id].include?('-39')
    redirect_to_brand(params[:id].gsub!('-pound', '')) if params[:id].include?('-pound')
  end

  def redirect_to_brand(id)
    product = Brand.cached_find id
    redirect_to brand_path(product), :status => :moved_permanently
  end
end
