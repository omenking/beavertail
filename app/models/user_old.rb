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
  
  ROLES = %w(admin user)

  attr_accessible :login,
                  :email,
                  :name,
                  :password,
                  :password_confirmation,
                  :first_name,
                  :last_name

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_email(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def admin?; role.role == 'admin'; end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

end
