$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'
require 'webmock'
VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures'
  c.hook_into :webmock
end

require 'timekitapi'
