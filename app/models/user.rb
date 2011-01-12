require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  concerned_with  :associations,
                  :callbacks,
                  :initializers,
                  :scopes,
                  :validation

  attr_accessible :login,
                  :email,
                  :name,
                  :password,
                  :password_confirmation,
                  :role,
                  :add_logs,
                  :remove_logs
  
  ROLES = %w(admin user)

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_email(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def admin?
    role.value == 'admin'
  end

  
  def get_logs(*args)
    admin? ? Log.all(*args) : logs.all(*args)
  end
  
  def has_log?(log)
    self.logs.collect{|c|c.id}.include?(log.id)
  end
  
  def role=(value)
    create_role(value)
  end
  
  def hidden_action_from(controller_action)
    c,a = controller_action.split(/#/)
    self.hidden_actions.find(:first,
      :conditions => {
        :controller_name => c,
        :action_name => a})
  end  
end
