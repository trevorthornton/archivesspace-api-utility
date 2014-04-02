## ArchivesSpace API Utility

A Ruby gem to facilitate interaction with the [ArchivesSpace](http://archivesspace.org/) REST API. Provides basic functionality for establishing and maintaining a session and performing GET and POST operations (using Ruby's Net::HTTP library).

For a more robust alternative, try Mark Cooper's [archivespace-client](https://github.com/mark-cooper/archivesspace-client]).

Documentation on the ArchivesSpace API can be found at http://archivesspace.github.io/archivesspace/doc/file.API.html.

## Installation

Add this line to your application's Gemfile:

    gem 'archivesspace-api-utility', :git => "https://github.com/trevorthornton/archivesspace-api-utility.git"

Then execute:

    bundle install


## Configuration

This gem requires an instance of ArchivesSpace to be running on an accessible server, which can be configured as follows (modified as appropriate):

```
ArchivesSpaceApiUtility.configure do |config|
  config.host = 'localhost'
  config.port = 8089
  config.username = 'admin'
  config.password = 'admin'
  config.https = false
end
```

This can be included in a script (after including ArchivesSpaceApiUtility), or, in a Rails app, you can just create a file called `archivesspace_config.rb` in `/config/initializers` and put the configuration in there.

## Usage

Include the module:

    include ArchivesSpaceApiUtility

Eastablish a connection:

    a = ArchivesSpaceSession.new
    
    => #<ArchivesSpaceApiUtility::ArchivesSpaceSession:0x0000010320a400 @session_token="f2a28285b4f94f341b833d405e4afb3d8aab4a8e9949516993db6b89bb5292c8", @auth_header={"X-ArchivesSpace-session"=>"f2a28285b4f94f341b833d405e4afb3d8aab4a8e9949516993db6b89bb5292c8"}>

### get(path,params={},headers={})

* path - See ArchivesSpace API documentation for available paths for GET
* params - optional query params (to append to URL)
* headers - optional HTTP Request headers

Make a GET request:

    response = a.get('/repositories')
    => #<Net::HTTPOK 200 OK readbody=true>

That returns a NET::HTTPResponse object. To get the response body (a JSON object):

```
response.body
 => "[{\"lock_version\":0,\"repo_code\":\"SCRC\",\"name\":\"Special Collections Research Center, North Carolina State University Libraries\",\"org_code\":\"SCRC\",\"parent_institution_name\":\"North Carolina State University Libraries\",\"url\":\"http://www.lib.ncsu.edu/scrc\",\"created_by\":\"admin\",\"last_modified_by\":\"admin\",\"create_time\":\"2014-03-17T13:13:12Z\",\"system_mtime\":\"2014-03-17T13:13:12Z\",\"user_mtime\":\"2014-03-17T13:13:12Z\",\"country\":\"US\",\"jsonmodel_type\":\"repository\",\"uri\":\"/repositories/2\",\"agent_representation\":{\"ref\":\"/agents/corporate_entities/1\"}}]\n"
 ```

And if you want that as a hash just use Ruby's JSON library

```
JSON.parse(response.body)
 => [{"lock_version"=>0, "repo_code"=>"SCRC", "name"=>"Special Collections Research Center, North Carolina State University Libraries", "org_code"=>"SCRC", "parent_institution_name"=>"North Carolina State University Libraries", "url"=>"http://www.lib.ncsu.edu/scrc", "created_by"=>"admin", "last_modified_by"=>"admin", "create_time"=>"2014-03-17T13:13:12Z", "system_mtime"=>"2014-03-17T13:13:12Z", "user_mtime"=>"2014-03-17T13:13:12Z", "country"=>"US", "jsonmodel_type"=>"repository", "uri"=>"/repositories/2", "agent_representation"=>{"ref"=>"/agents/corporate_entities/1"}}]
 ```

### post(path,data,headers={})

* path - See ArchivesSpace API documentation for available paths for POST
* data - Data to be sent in request body. This will be sent as a JSON object (you can pass in a hash and it will be converted to JSON before the request is made). The content and validity of your post data is between you and ArchivesSpace - if there is a problem the API should return a response explaining what the problem was. A bit of guidance can be found by looking at the JSON schema documents [here](https://github.com/hudmol/archivesspace/tree/master/common/schemas).
* headers - optional HTTP Request headers

Just like `get`, `post` will return a NET::HTTPRequest object.

## License

See MIT-LICENSE