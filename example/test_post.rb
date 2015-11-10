require 'archivesspace-api-utility'
require './as_config_local.rb'

# initialize connection
@a = ArchivesSpaceApiUtility::ArchivesSpaceSession.new

# Specify record URI/API endpoint
path = '/repositories/2/resources/23'

# Execute get request and receive response
response = @a.get(path)

# COnvert JSON data to Ruby hash
data = JSON.parse(response.body)

# change things in the hash
data['publish'] = true

# post updated object (hash will be converted to JSON before the request)
post_response = @a.post(path,data)

# output
puts post_response.body
