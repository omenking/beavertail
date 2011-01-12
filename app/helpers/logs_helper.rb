module LogsHelper
  def log_form_for(log,&proc)
    form_for log,
      :html => {
        :class => 'log_form'},
      &proc
  end
  
  def log_navigation
    partial 'logs/navigation'
  end
  
  def log_fields(f)
    partial 'logs/fields', locals(binding)
  end

  def log_log_type_options(log)
    options = []
    for name,format in Log::FORMATS
      options << [format,name]
    end
    options
  end
  
  def list_logs(logs)
    html = partial('logs/list_header')
    html << wrap_html(:logs, partial('logs/log',logs))
  end
  
  def log_attrs(log)
    a = attrs
    a[:log_id] = log.id
    attrs(a)
  end
  
  def log_name(log)
    wrap_html :name, log_link(log)
  end
  
  def log_link(log)
    link_to(log.name,log_path(log))
  end
  
  def log_mtime(log)
    wrap_html :mtime, log.mtime
  end
end