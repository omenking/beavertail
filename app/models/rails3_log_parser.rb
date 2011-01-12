class Rails3LogParser < LogParser
  def line_regexps
    @lines ||= {
      :start =>
        %r{^\s*Started ([A-Z]+) ".*?" for ([0-9\.]+) at ([0-9\-:\s]+)},
      
      :processing_by => [
        %r{\s*Processing by (.*?)#(.*?)\s}],
      :exception_backtrace => [
        # /Users/tye/Sites/tyeca/app/helpers/topics_helper.rb:42: syntax error, unexpected ')'
        %r{^(.*?)([^\s]+):(\d+)(:\s*syntax error.*)$}i,
        #    app/models/log.rb:60:in `start'
        %r{^(.*?)([^\s]+):(\d+)(:in `[^`']+'.*)}i],
      :backtrace_server => [
        %r{^(.*server\.rb):(\d+)$}],
      :parameters => [
        #      Parameters: {"action"=>"show", "id"=>"1", "controller"=>"logs"}
        %r{^\s*Parameters: (.*)$}],
      :sql => [
        # Log Load (0.2ms)   SELECT * FROM `logs` WHERE (`logs`.`id` = 1) 
        # CACHE (0.0ms)   SELECT * FROM `logs` 
        %r{^\s{2}([A-Z]+\s+(?:Columns|Load|Update|Delete all|Destroy|Create)|CACHE|SQL)(\s+\([\d\.]+ms\)\s+)(.*)}i],
      :exception_on_line => [
        %r{(.*)( on line #)(\d+)( of )(.*?):$}],
      :render => [
        # Rendered rescues/_trace (44.1ms)
        %r{^(Render(?:ing|ed)\s+(?:template within)?\s*)([^\s]*)(\s+\(.*?\))?}],
      :complete => [
        %r{Completed in (.+)ms}]
    }
  end
  
  def parse(name,entry,line,args)
    case name
    when :start
      # has to return [controller,action,ip,date,method]
      method,ip,date = args
      ['','',ip,date,method]
      
    when :processing_by
      c,a = args
      entry.controller_name = c
      entry.action_name = a
    when :exception_backtrace
      start,filename,line_number,in_func = args
      class_name = (start =~ %r{^.*\s\(.*?\)} || filename =~ %r{^/}) ? 'full_backtrace' : 'backtrace'
      entry.has_errors = true
      [class_name,"<span>#{h(start)}</span>#{textmate_link(filename,line_number)}:<span>#{h(line_number)}#{h(in_func)}</span>"]
    when :parameters
      params = args[0].gsub(/(\#\<[^>]+\>)/,'%q(\1)')
      begin
        entry.parameters = eval(params)
      rescue
        raise "Unable to parse parameters: #{args[0].inspect}"
      end
    when :sql
      type,time,query = args
      ['sql',"<span>#{h(type + time)}</span><span class='query'>#{h(query)}</span>"]
    when :exception_on_line
      start,on_line,line_number,of,file = args
      entry.has_errors = true
      ['error', "<span class='error'>#{h(start)}</span><span>#{h(on_line+line_number+of)}}</span></span>#{textmate_link(file,line_number)}"]
    when :render
      render,template,after = args
      ['render',"<span>#{h(render)}</span><span class='filename'>#{h(template)}</span><span>#{h(after)}</span>"]
    when :complete
      entry.speed = $1.to_i
      ['complete',h(line)]
    end

  end
end