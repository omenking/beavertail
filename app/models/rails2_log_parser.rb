class Rails2LogParser < LogParser
  def line_regexps
    @lines ||= {
      :start =>
        #   Processing LogsController#show (for 127.0.0.1 at 2010-08-03 15:07:04) [GET]
        %r{^Processing ([A-Za-z:_0-9]+)#([0-9_A-Za-z]+).*for\s([\d\.]+)\sat ([0-9\-:\s]+)\).*\[([A-Z]+)\]},
      
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
        %r{(.*)(on line #)(\d+)( of )(.*?):$}],
      :render => [
        # Rendered rescues/_trace (44.1ms)
        %r{^(Render(?:ing|ed)\s+(?:template within)?\s*)([^\s]*)(\s+\(.*?\))?}],
      :complete => [
        %r{Completed in (.+?)ms}]
    }
    @lines
  end

  def parse(name,entry,line,args)
    case name
    when :start
      # has to return [controller,action,ip,date,method]
      args

    when :exception_backtrace
      start,filename,line_number,in_func = args
      class_name = (start =~ %r{^.*\s\(.*?\)} || filename =~ %r{^/}) ? 'full_backtrace' : 'backtrace'
      entry.has_errors = true
      [class_name,"<span>#{h(start)}</span>#{textmate_link(filename,line_number)}:<span>#{h(line_number)}#{h(in_func)}</span>"]

    when :exception_on_line
      before,on_line,line_number,of,filename = args
      entry.has_errors = true
      ['error', "<span class='error'>#{h(before)}</span><span>#{h(on_line)}#{h(line_number)}#{h(of)}</span></span>#{textmate_link(filename,line_number)}"]
      
    when :backtrace_server
      file,line_number = args
      ['full_backtrace',"#{textmate_link(file,line_number)}"]

    when :sql
      command,time,query = args
      ['sql',"<span>#{h(command) + h(time)}</span><span class='query'>#{h(query)}</span>"]

    when :render
      render,template,after = args
      ['render',"<span>#{h(render)}</span><span class='filename'>#{h(template)}</span><span>#{h(after)}</span>"]

    when :parameters
      params = args.shift
      params.gsub!(/(\#\<[^>]+\>)/,'%q(\1)')
      begin
        entry.parameters = eval(params)
      rescue Exception => e
        raise "Unable to parse parameters: #{params} - #{e.message}"
      end
      nil

    when :complete
      time = args.shift
      entry.speed = time.to_i
      ['complete',h(line)]
    end
  end

  def get_cache_name(c,a,ip,date,method)
    Digest::MD5.hexdigest("#{c}#{a}#{ip}#{date}")
  end
end