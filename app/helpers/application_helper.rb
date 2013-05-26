module ApplicationHelper
  def link_to_product(product, type = :short, options = {})
    defaults = {:title => raw(product) }

    title = (type == :short ? product.short_title : product)
    return link_to raw(title), product_path(product), defaults.merge(options)
  end

  def link_to_advertiser(advertiser, type = :short, options = {})
    defaults = {:title => raw(advertiser) }

    title = (type == :short ? advertiser.short_title : advertiser)
    return link_to raw(title), advertiser_path(advertiser), defaults.merge(options)
  end

  def avatar_of_product(product, link_options = {}, image_options = {})
    default_link_options = { :title => raw(product) }
    default_image_options = {:title => raw(product), :alt => raw(product)}

    return link_to image_tag(product.aw_image_url, default_image_options.merge(image_options)), product_path(product), default_link_options.merge(link_options)
  end

  def link_to_brand(brand, type= :short, options ={})
    return 'Brand Not Available' if category.nil?
    defaults = {:title => raw(brand) }

    title = (type == :short ? brand.short_title : brand)
    return link_to raw(title), brand_path(brand), defaults.merge(options)
  end

  def link_to_category(category, type = :short, options = {})
    return 'Category Not Available' if category.nil?

    defaults = {:title => raw(category) }

    title = (type == :short ? category.short_title : category)
    return link_to raw(title), category_path(category), defaults.merge(options)
  end
end
