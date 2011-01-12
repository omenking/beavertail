module EntriesHelper
  def request_name(entry)
    html = []
    html << content_tag(:span, entry.controller_link(@log.root).html_safe,:class => 'controller')
    html << ' : '
    html << content_tag(:span,entry.action_name,:class => 'action')
    html.join('').html_safe
  end
    
  def insert_entry(entry)
    page.insert_html :top, 'entries', 
      :partial => 'entries/entry', 
      :locals => { :entry => entry }    
  end
  
  def replace_entry(entry)
    page.replace "entry_#{entry.hash}",
      :partial => 'entries/entry',
      :locals => { :entry => entry }
  end

  def entry_attrs(entry)
    a = attrs
    a[:class] << 'errors' if entry.has_errors?
    a[:class] << 'hidden' if @hidden.include?("#{entry.controller_name}##{entry.action_name}")
    a[:hash] = entry.hash
    a[:content_hash] = entry.content_hash
    a[:controller_action] = "#{entry.controller_name}##{entry.action_name}"
    a[:action_name] = entry.action_name
    a[:id] = "entry_#{entry.hash}"
    attrs(a)
  end
  
  def list_entries(log,entries)
    html = ''
    for entry in entries
      if entry.is_a?(String)
        cache_html = Rails.cache.read(entry.cache_name)
          html << cache_html
      else
        cache_html = partial('entries/entry',
          :entry => entry,
          :log => log)
        html << cache_html
        Rails.cache.write(entry.cache_name,cache_html)
      end
    end
    wrap_html :entries, html.html_safe
  end                            

  def list_controllers(controllers)
    html = ''
    for controller_name,actions in controllers
      html << partial('logs/controller',
        :controller_name => controller_name,
        :actions => actions)
    end
    html.html_safe
  end
  
  def list_controller_actions(controller_name,actions)
    wrap_partial :actions, 'logs/action', actions,
      :controller_name => controller_name
  end
  
  def action_is_hidden?(controller_name,action)
    @hidden.include?("#{controller_name}##{action}")
  end
  
  def action_checkbox(controller_name,action)
    check_box_tag "", "",
      action_is_hidden?(controller_name,action),
      :id => "hide_#{controller_name}_#{action}",
      :controller_action => "#{controller_name}##{action}",
      :class => 'hide_controller_action'
  end
  
  def action_label(controller_name,action)
    label_tag "hide_#{controller_name}_#{action}",
      action
  end
  
  def display_controller_name(controller_name)
    wrap_html :name, (controller_name.match(/^(.*)Controller$/) ? $1 : '')
  end
  
  def entry_params(entry)
    html = ''
    for name,value in entry.parameters
      param_value = (value.inspect =~ %r{^"(.*)"$} ? $1.gsub(%r{\\(.)},'\1') : value.inspect)
      html << partial('entries/param',
        :name => name,
        :value => param_value)
    end
    html << content_tag(:div, '', :class => 'clear')
    wrap_html :parameters, html.html_safe
  end
  
  def entry_content(entry)
    html = ''
    for class_name,line in entry.content
      html << wrap_html(class_name, line.html_safe, 
          :style => (class_name == 'full_backtrace' && !@show_full_backtrace ? 'display: none' : ''))
    end
    wrap_html :entry_content, html.html_safe
  end
  
  def entry_method(entry)
    wrap_html :method, entry.method
  end
  
  def entry_address(entry)
    wrap_html :address, entry.address
  end
  
  def entry_time(entry)
    unless entry.time.to_date.day == Time.now.to_date.day
      content_tag(:span,
        entry.time.strftime('%b-%d-%y %I:%M:%S %p'),
        :class => 'time') 
    else
      content_tag(:span,
        entry.time.strftime('%I:%M:%S %p'),
        :class => 'time')
    end
  end
  
  def entry_errors_or_speed(entry)
    if entry.has_errors?
      image_tag('error.png',:class => 'error') 
    else
      wrap_html :speed, "#{entry.speed}ms" unless [nil,0].include?(entry.speed)
    end
  end
end