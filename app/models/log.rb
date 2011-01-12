class Log < ActiveRecord::Base
  FORMATS = {
    :rails3 => "Rails 3.x",
    :rails2 => "Rails 2.x"}
  USE_MEMCACHE = false
  
  attr_accessor :controllers, :format, :entries
  
  def after_initialize
    @entries = []
    @controllers = {}
  end
  
  def path
    File.expand_path(read_attribute(:log_path))
  end
  
  def root
    File.expand_path(read_attribute(:root_path))
  end
  
  def sinc(name)
    self.class.send(:include,name)
  end
  
  def read_log
    begin
      parser = "#{log_type.camelize}LogParser".constantize.new(path,log_type,root)
    rescue NameError => e
      raise "Unable to load log parser for log type #{log_type}: #{e}"
    end
    @entries, @controllers = parser.get_entries
    @entries.reverse!
  end
  
  def observable?(user)
    user.get_logs.collect{|c|c.id}.include?(self.id)
  end
end