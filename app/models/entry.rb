require 'digest/md5'
class Entry
  attr_accessor :controller_name,
                :action_name,
                :content,
                :parameters,
                :time,
                :has_errors,
                :hash,
                :content_hash,
                :speed,
                :address,
                :method,
                :path,
                :cache_name
                
  def initialize(controller,action,time,address,method,cache_name)
    @controller_name = controller
    @action_name = action
    @time = DateTime.parse(time)
    @content = []
    @parameters = {}
    @speed = 0
    @has_errors = false
    @address = address
    @method = method
    @cache_name = cache_name
    @path = nil
  end
  
  def has_errors?; has_errors; end
  
  def hash!
    @hash = Digest::MD5.hexdigest(
      @controller_name + @action_name + @time.to_s)
    @content_hash = Digest::MD5.hexdigest(@content.join(""))
  end
  
  def controller_link(root)
    controller = @controller_name.sub(/Controller$/,'')
    path = File.join(root,'app','controllers',controller.split(/::/).map{|s|s.downcase}) + '_controller.rb'
    "<a href='" +
    "txmt://open/?url=file://#{File.expand_path(path)}&line=1&column=1" +
    "' class='textmate_link'>#{controller}</a>"
  end
end