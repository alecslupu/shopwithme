class ProductsController < ApplicationController
  
  
  before_filter :find_product, :only => [:show, :visit]
  before_filter :redirect_to_product_view, :only => [ :show ]  


  def show
    unless @product.nil?

      if request.path != product_path(@product)
        redirect_to @product, status: :moved_permanently and return 
      end

      log_product_view(@product)
    end
  end 

  def visit
    render :text => "", :status => :gone  and return if bot?
    redirect_to ("http://www.shop-with.me"+visit_product_path(@product)) and return 
  end

  private 

  def redirect_to_product_view
    if current_admin.nil?  and not bot? 
      redirect_to visit_product_path(@product) and return 
    end
  end 

  def find_product
    @product = Product.cached_find(params[:id])
  end

  def bot?
    request.user_agent.match(Split.configuration.robot_regex)
  end

  def skip_log
    return ( not request.referer.nil? and request.referer.start_with?(root_url) and not bot? and not current_admin )
  end

  def log_product_view(product) 
    product.display_logs.create({
      :referrer => request.referer, 
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    }) unless skip_log 

  end 

  def log_product_visit(product)
    product.visit_logs.create({
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    }) unless bot?
  end
end
