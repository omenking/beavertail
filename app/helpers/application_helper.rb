# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def ef(e); page << "if($('#{e}').length != 0){"; end
  def esf(e); page << "}else if($('#{e}')){"; end
  def els; page << "}else{"; end
  def en; page << "}"; end

  def reload_javascript_events
      page << "Event.addBehavior.reload()"
  end

  def show_full_backtrace_checkbox
    html = check_box_tag '', '', @show_full_backtrace,
      :id => 'show_full_backtrace'
    html << label_tag('show_full_backtrace','Show full backtraces')
    content_tag :div, html, :class => "option"
  end
  
  def freeze_updates_checkbox
    html = check_box_tag '', '', false,
      :id => 'freeze_updates'
    html << label_tag('freeze_updates','Freeze')
    content_tag :div, html, :class => "option"
  end
  
  def partial(name,*args)
    arg_options = args.extract_options!
    options = {}
    options[:as] = arg_options[:as] if arg_options.key?(:as)
    options[:collection] = args.shift if args.length > 0
    options[:locals] = arg_options
    options[:partial] = name
    render options
  end
  
  def wrap_html(class_name,*args)
    options = args.extract_options!
    insert = options.delete(:insert) if options.key?(:insert)
    html = args.shift
    class_name = [class_name] unless class_name.is_a?(Array)
    for c in class_name.reverse
      html = content_tag(:div,html,
        {:class => c, :id => c}.merge(options))
    end
    html = insert[:top] + html if insert && insert.key?(:top)
    html << insert[:bottom] if insert && insert.key?(:bottom)    
    html
  end
  
  def wrap_partial(class_name,*args)
    arg_options = args.extract_options!  
    html_options = arg_options.delete(:html) if arg_options.key?(:html)    
    args << arg_options
    wrap_html(class_name,partial(*args),html_options)
  end
  
  def app_text_field(f,name,*args)
    options = args.extract_options!
    type = (args.length > 0 ? args.shift : :text_field)
    html = f.label(name,t(".#{name}"))
    html << wrap_html(:intro,t(".#{name}_intro")) if options.try('[]',:intro) == true
    html << f.send(type,name,options)
    wrap_html "text_field #{type != 'text_field' ? type : ''} #{name}", html
  end
  
  def app_select(f,name)
    html = f.label(name,t(".#{name}"))
    html << f.select(name,send("#{f.object.class.name.underscore}_#{name}_options",f.object))
    wrap_html "select #{name}", html
  end
  
  def app_check_box(f,name)
    html = f.check_box(name)
    html << f.label(name,t(".#{name}"))
    wrap_html "check_box #{name}", html
  end
  
  def app_submit(f)
    wrap_html :submit, submit_tag(t('.submit'))
  end
  
  def locals(helper_binding,*locals)
    options = locals.extract_options!
    result = {}
    vars = eval("local_variables",helper_binding)
    for var in vars
      next if var == 'html'
      result[var.to_sym] = eval("#{var}",helper_binding)
    end
    result.merge!(options)
  end
  
  def location_name
    "#{action_name}_#{controller_name}"
  end
  
  def body_attrs
    a = attrs
    a[:logs_hidden] = @hidden.to_json
    a[:class] << location_name
    attrs(a)
  end
  
  def attrs(a=nil)
    if a
      a[:class] = a[:class].join(' ')
      a
    else
      {:class => []}
    end
  end
  
  def navigation
    partial 'shared/navigation'
  end
  
  def header
    wrap_html :header, (logged_in? ? navigation + partial('shared/log_tab_nav') : '')
  end
  
  def clear
    content_tag(:div,'',:class => 'clear')
  end
end
