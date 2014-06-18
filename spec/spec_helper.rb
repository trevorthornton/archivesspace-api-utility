require 'bundler/setup'
Bundler.setup

require 'archivesspace-api-utility'
require 'net/http'
require 'json'
require 'uri'

RSpec.configure do |config|
  # some (optional) config here
  ARCHIVESSPACE_TEST_PATHS = {
    resource: '/repositories/2/resources/1315'
  }
end