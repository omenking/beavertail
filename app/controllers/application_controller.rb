require 'authenticated_system'
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all
  protect_from_forgery

  before_filter :require_login
  before_filter :sort_logs
  before_filter :load_options
  
  def options
    if params.has_key?(:show_full_backtrace)
      session[:show_full_backtrace] = params[:show_full_backtrace] == 'true' ? true : false
    end
  end
  
  private
    def sort_logs
      return unless logged_in?
      require_login
      @logs = current_user.get_logs
      for log in @logs
        if File.exists?(log.path)
          log.mtime = File.new(log.path).mtime
        else
          @logs.delete(log)
        end
      end
      @logs.sort! { |a,b| b.mtime <=> a.mtime }
    end
  
    def load_options
      return unless logged_in?
      session[:show_full_backtrace] ||= false
      @hidden = current_user.hidden_actions.collect{|c|"#{c.controller_name}##{c.action_name}"}
      @show_full_backtrace = session[:show_full_backtrace]
    end
  
    def require_login
      redirect_to root_path unless logged_in?
    end
  
    def require_admin
      redirect_to root_path unless current_user.admin?
    end
end
