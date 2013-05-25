class PopulatePromoteUrl < ActiveRecord::Migration
  def up
    
    Advertiser.all.each do |a|
      a.promote_url = "http://www.awin1.com/awclick.php?mid=#{a.id}&id=176745"
      a.save
    end
  end

  def down
  end
end
