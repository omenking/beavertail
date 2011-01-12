class LogsController < ApplicationController
  before_filter :load_log, :only => [:show,:update,:pull]
  before_filter :require_admin, :only => [:new,:create,:update,:destroy]
  before_filter :require_log_observable, :except => [:index,:new,:create]
  
  def new
    @log = Log.new
  end
  
  def create
    @log = Log.new(params[:log])
    if @log.save
      redirect_to log_path(@log)
    else
      render :new
    end
  end
  
  def show
    current_user.create_log_role(@log,'user') unless current_user.has_log?(@log)
    @log.read_log
    @entries = @log.entries.reject { |c| !c.is_a?(String) && (c.controller_name == '' || c.action_name == '')}
  end
  
  def pull
    @log.read_log
    if true # || !log_file_mdate || @log.mtime != log_file_mdate.mdate
      @log.entries.reverse!
      if q = @log.entries[-(params[:max].to_i - 1)..-1]
        @log.entries = q
      end
      @log.entries.reject! { |c| c.controller_name == '' || c.action_name == ''}
      respond_to{|f|f.js {render :layout => false}}
    else
      render :nothing => true
    end
  end

  private
    def load_log
      @log = Log.find(params[:id])
    end
  
    def require_log_observable
      redirect_to root_path unless @log.observable?(current_user)
    end
end