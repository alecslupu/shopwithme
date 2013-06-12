class RedirectLink < ActiveRecord::Base
  attr_accessible :from_link, :redirect_count, :to_link
end
