class CategoryDemon < JobUtilsDemon
  # def initialize(args)
  # end

  def process
    process_categories(get_data)
  end
  
  private 

  def feed_deflated 
    @deflated_name ||= "#{Time.now.to_i.to_s}_categories.csv"
  end

  def feed_archive
    @archive_name ||= "#{Time.now.to_i.to_s}_categories.zip"
  end 

  def domain 
    "datafeeds.productserve.com"
  end 

  def feed_url 
    "/datafeed_category.php?user=#{user_id}&password=#{user_password}&format=CSV&compression=zip"
  end 

  def process_categories(elements)
    coder = HTMLEntities.new

    elements.sort_by! {|e| coder.decode(e["Category Name"]) }
    elements.each do |row|
      cat = Category.where(:id => row["Category ID"].to_i).first_or_initialize
      # cat.id = cat.awid.to_i
      cat.name = coder.decode(row["Category Name"])
      cat.is_adult = (row["Is Adult"].to_i == 1)
      cat.description = coder.decode(row["Category Description"])
      cat.save
    end

    elements.each do |row|
      cat = Category.where(:id => row["Category ID"].to_i).first
      parent = Category.where(:id => row["Category Parent Id"].to_i).first 
      if cat and parent
        cat.move_to_child_of(parent)
      end
    end
  end
  
end