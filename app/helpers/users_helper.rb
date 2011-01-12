module UsersHelper

  def list_users(users)
    header = css_table_header(
      :users_header,
      'users.index.caption',
      %w(name email role actions))
    wrap_html(:users,header + partial('users/user',users))
  end
  
  def css_table_header(css_class,i18n_prefix,fields)
    html = ''
    for field in fields
      html << wrap_html(field,t("#{i18n_prefix}.#{field}"))
    end
    html << clear
    wrap_html css_class, html.html_safe
  end
  
  def user_attrs(user)
    a = {}
    a[:id] = "user_#{user.id}"
    a[:user_id] = user.id
    a
  end
  
  def user_role_select(user)
    options = []
    for role in User::ROLES
      options << [t("users.roles.#{role}"),role]
    end
    html = wrap_html(:loading,image_tag('loading.gif'))
    html << select_tag(:role,
      options_for_select(options,user.role.value),
      :class => 'user_role_select')
    wrap_html :role, html
  end
  
  def delete_user_link(user)
    link_to 'delete', '#'
  end
  
  def user_logs(user)
    html = ''
    log_html = user.logs.collect do |log|
      link_to(log.name,'',
        :onclick => 'return false',
        :class => 'user_log_link',
        :user_id => user.id,
        :log_id => log.id,
        :confirm_text => t('users.index.confirm.log_delete'))
      end
    html << log_html.join(', ')
    wrap_html :logs, html.html_safe
  end

  def list_user_logs(logs)
    html = partial('users/log',logs)
    wrap_html :user_logs,html
  end
  
  def user_log_attrs(log)
    a = {}
    a[:id] = "user_log_#{log.id}"
    a[:log_id] = log.id
    a
  end

end
