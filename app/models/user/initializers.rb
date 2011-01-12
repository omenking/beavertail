class User
  def add_logs=(logs)
    add_logs(logs)
  end
  
  def add_logs(log_ids)
    for log_id in log_ids
      if log = Log.find_by_id(log_id)
        Role.delete_all(
          ['log_id = ? AND user_id = ?',
          log.id, self.id])
        Role.create(
          :user_id => self.id,
          :log_id => log.id,
          :role => 'user')
      end
    end
  end
  
  def remove_logs=(logs)
    remove_logs(logs)
  end
  
  def remove_logs(log_ids)
    for log_id in log_ids
      if log = Log.find_by_id(log_id)
        Role.delete_all(
          ['log_id = ? AND user_id = ?',
            log.id, self.id])
      end
    end
  end
  
  def create_role(role='user')
    Role.delete_all(['user_id = ? AND log_id IS NULL',self.id])
    Role.create(
      :user_id => self.id,
      :role => role,
      :log_id => nil)
  end
  
  def create_log_role(log,role='user')
    Role.delete_all(["user_id = ? AND log_id = ?",self.id,log.id])
    Role.create(
      :user_id => self.id,
      :role => role,
      :log_id => log.id)
  end
  
  def create_hidden(log_id,controller_action)
    c, a = controller_action.split(/#/)
    HiddenAction.delete_all(['log_id = ? AND controller_name = ? AND action_name = ?',
        log_id,c,a])
    self.hidden_actions.create(
      :log_id => log_id,
      :controller_name => c,
      :action_name => a)
  end
end