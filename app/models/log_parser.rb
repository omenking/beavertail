class LogParser
  def initialize(path,log_type,root)
    @path = path
    @log_type = log_type
    @root = root
  end
  
  def strip_ansi!(text)
    text.gsub!(%r{\e\[[0-9;]+m},'')
  end
  
  def get_entries
    lines = `tail -n 1000 #{@path}`.split("\n")
    entries = []
    entry = false
    for line in lines
      strip_ansi!(line)
      if match = line.match(line_regexps[:start])
        if entry
          entry.hash!
          entries << entry 
        end
        args = match.to_a.from(1)
        controller,action,ip,date,method = parse(:start,entry,line,args)
        entry = Entry.new(controller,action,date,ip,method,'cache_name')
      elsif entry
        line_matched = false
        for line_type in line_regexps.keys
          next if line_type == :start
          for regexp in line_regexps[line_type]
            if match = line.match(regexp)
              line_matched = true
              args = match.to_a.from(1)
              result = parse(line_type,entry,line,args)
              entry.content << result if result.is_a?(Array)
            end
          end
        end
        unless line_matched
          entry.content << ['normal',h(line)]
        end
      end
    end
    if entry
      entry.hash!
      entries << entry 
    end
    controllers = {}
    for entry in entries
      controller,action = [entry.controller_name,entry.action_name]
      controllers[controller] ||= []
      controllers[controller] << action unless controllers[controller].include?(action) || action == ''
    end
    [entries,controllers]
  end
  
  def controller_name=(value)
  end
  
  def action_name=(value)
  end
  
  def textmate_link(file,line)
    file_path = (file =~ %r{^/|~} ? file : "#{@root}/#{file}")
    "<a href='" +
    "txmt://open/?url=file://#{file_path}&line=#{line}&column=1" +
    "' class='textmate_link'>#{file}</a>"
  end
  
  def h(text)
    return unless text
    text = text.gsub(/&/,'&amp;')
    text = text.gsub(/</,'&lt;')
    text = text.gsub(/>/,'&gt;')
    text
  end
  
  private
  
  def _collect_controller_action
  end
end