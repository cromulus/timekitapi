require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'json'
require 'net/http/persistent'

require 'timekitapi/version'
require 'timekitapi/config'
require 'timekitapi/client'

module TimekitApi
  @config = Config.new

  def self.config(opts = nil)
    @config.update(opts) unless opts.nil?
    @config
  end
end
