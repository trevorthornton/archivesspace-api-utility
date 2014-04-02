$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archivesspace-api-utility/version"

Gem::Specification.new do |s|
  s.name        = 'archivesspace-api-utility'
  s.version     = ArchivesSpaceApiUtility::VERSION
  s.date        = '2014-04-01'
  s.summary     = "A lightweight utility to facilitate interaction with the ArchivesSpace backend API."
  s.description = "A lightweight utility to facilitate interaction with the ArchivesSpace backend API."
  s.authors     = ["Trevor Thornton"]
  s.email       = 'hellotrevorthornton@gmail.com'
  s.files       = ["lib/archivesspace-api-utility.rb", "lib/archivesspace-api-utility/configuration.rb"]
  s.homepage    =
    'http://github.com/trevorthornton/archivesspace-api-utility'
  s.license       = 'MIT'

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rspec"
end