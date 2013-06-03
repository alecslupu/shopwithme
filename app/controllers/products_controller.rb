class ProductsController < ApplicationController
  before_filter :ensure_search_term_presence, :only => [ :search ]
  before_filter :fix_missing_products , :only => [ :show, :visit ]
  before_filter :redirect_to_product_view, :only => [ :show ]

  def index 
    product_count = Rails.cache.fetch('all_products_count',:expires_in => 6.hours) { Product.count }
    @products = Product.includes(:category, :advertiser, :brand).page_with_cached_total_count params[:page], product_count
  end

  def show
    begin
      @product = Product.cached_find(params[:id])
      log_product_view(@product) unless @product.nil?
    rescue ActiveRecord::RecordNotFound => e
      render 'error/404', :layout => 'error', :status => :not_found
    end
  end 

  def search 
    @products = Product.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
  end 

  def visit
    ab_tests_finish unless bot?

    product = Product.find(params[:id])
    log_product_visit(product) unless product.nil?

    redirect_to product.aw_deep_link
  end

  private 
  def redirect_to_product_view
    unless bot?
      redirect_to visit_product_path(@product) and return
    end
  end 

  def bot?
    request.user_agent.match(Split.configuration.robot_regex)
  end

  def ab_tests_finish
    finished('hide_price_in_show_page')
    finished('cta_visit_text')
    finished('cta_visit_color')
    finished('cta_visit_size')
    finished('details_link_to_visit_in_listing')
  end 

  def log_product_view(product) 
    product.display_logs.create({
      :referrer => request.referer, 
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    }) unless !request.referer.nil? && request.referer.start_with?(root_url)

  end 

  def log_product_visit(product)
    product.visit_logs.create({
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    })
  end

  def ensure_search_term_presence
    if params[:search].blank?
      redirect_to(products_path) and return 
    end 
  end 

  def fix_missing_products
    params[:old_id] = params[:id]
    params[:id].gsub!('-amp', '')    if params[:id].include?('-amp')
    params[:id].gsub!('-quot', '')   if params[:id].include?('-quot')
    params[:id].gsub!('-39', '')    if params[:id].include?('-39')
    params[:id].gsub!('-pound', '')  if params[:id].include?('-pound')
    redirect_to_product(params[:id]) if params[:old_id] != params[:id]
  end

  def redirect_to_product(id)
    product = Product.cached_find id
    redirect_to(product_path(product), :status => :moved_permanently) and return
  end
end
