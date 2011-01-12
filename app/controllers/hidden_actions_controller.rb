class HiddenActionsController < ApplicationController
  before_filter :find_hidden_action, :only => [:destroy]
  before_filter :require_editable, :only => [:destroy]
  
  def create
    current_user.create_hidden(params[:log_id],params[:controller_action])
    render :nothing => true
  end
  
  def destroy
    @hidden_action.destroy
    render :nothing => true
  end

  private
    def find_hidden_action
      @hidden_action = current_user.hidden_action_from(params[:controller_action])
    end
  
    def require_editable
      redirect_to root_path unless @hidden_action.editable?(current_user)
    end
end

