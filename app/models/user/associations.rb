class User
  has_many :recent_logs
  has_many :roles
  has_many :logs,
    :through => :roles,
    :order => 'roles.created_at'
  has_many :user_logs
  has_many :hidden_actions
  
  has_one :role,
    :conditions => {
      :log_id => nil }
  
end