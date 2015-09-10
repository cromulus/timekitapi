require "timekitapi/version"
require "timekitapi/config"

module TimekitApi
  @config = Config.new

  def self.config(opts=nil)
    @config.update(opts) if !opts.nil? 
    @config
  end

end
