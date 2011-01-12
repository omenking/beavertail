class HiddenAction < ActiveRecord::Base
  belongs_to :log
  belongs_to :user
  
  def editable?(u); user == u; end
end