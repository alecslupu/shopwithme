module ApplicationHelper
  def link_to_product(product, type = :short, options = {})
    return if product.nil?
    defaults = {:title => product }

    title = (type == :short ? product.short_title : product)
    return link_to title, product_path(product), defaults.merge(options)
  end

  def avatar_of_product(product, link_options = {}, image_options = {})
    return if product.nil? || product.aw_image_url.blank? || !product.aw_image_url.starts_with?('http')
    default_link_options = { :title => product }
    default_image_options = {:title => product, :alt => (product)}

    return link_to image_tag(product.aw_image_url, default_image_options.merge(image_options)), product_path(product), default_link_options.merge(link_options)
  end

  def link_to_advertiser(advertiser, type = :short, options = {})
    return 'Merchant name Not Available' if advertiser.nil?
    defaults = {:title => (advertiser) }

    title = (type == :short ? advertiser.short_title : advertiser)
    return link_to (title), advertiser_path(advertiser), defaults.merge(options)
  end

  def avatar_of_advertiser(advertiser, link_options = {}, image_options = {})
    return if advertiser.nil?
    default_link_options = { :title => (advertiser.strapline), :class => 'pull-left' }
    default_image_options = {:title => (advertiser.strapline), :alt => (advertiser.strapline)}

    return link_to image_tag(advertiser.logo, default_image_options.merge(image_options)), advertiser_path(advertiser), default_link_options.merge(link_options)
  end

  def link_to_brand(brand, type= :short, options ={})
    return 'Brand Not Available' if brand.nil?
    defaults = {:title => (brand) }

    title = (type == :short ? brand.short_title : brand)
    return link_to (title), brand_path(brand), defaults.merge(options)
  end

  def link_to_category(category, type = :short, options = {})
    return 'Category Not Available' if category.nil?

    defaults = {:title => (category) }

    title = (type == :short ? category.short_title : category)
    return link_to (title), category_path(category), defaults.merge(options)
  end
end
