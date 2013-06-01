class ProductVisitLog < ActiveRecord::Base
  belongs_to :product
  attr_accessible :ip, :user_agent
end
