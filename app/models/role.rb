class Role < ActiveRecord::Base
  belongs_to :log
  
  def value; role; end
end