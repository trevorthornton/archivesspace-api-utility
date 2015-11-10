require 'archivesspace-api-utility'
require './as_config_local.rb'

# initialize connection
@a = ArchivesSpaceApiUtility::ArchivesSpaceSession.new

# Specify record URI/API endpoint
path = '/repositories/2/resources/23'

# Execute get request and receive response
response = @a.get(path)

# Output
puts response.body
