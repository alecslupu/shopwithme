class ProductDisplayLog < ActiveRecord::Base
  belongs_to :product
  attr_accessible :ip, :referrer, :user_agent
end
