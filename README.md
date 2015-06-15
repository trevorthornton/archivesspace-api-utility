## ArchivesSpace API Utility

A Ruby gem to facilitate interaction with the [ArchivesSpace](http://archivesspace.org/) REST API. Provides basic functionality for establishing and maintaining a session and performing GET and POST operations (using Ruby's Net::HTTP library). This gem works at a fairly low level and just makes it a bit easier to interact with the API in your Ruby code, but without a lot of abstraction. For a more robust alternative, you might try Mark Cooper's [archivespace-client](https://github.com/mark-cooper/archivesspace-client).

Documentation on the ArchivesSpace API can be found at http://archivesspace.github.io/archivesspace/doc/file.API.html.

## Installation

Add this line to your application's Gemfile:

    gem 'archivesspace-api-utility', :git => "https://github.com/trevorthornton/archivesspace-api-utility.git"

Then execute:

    bundle install


## Configuration

This gem requires an instance of ArchivesSpace to be running on an accessible server, which can be configured like this (modified as appropriate):

```
ArchivesSpaceApiUtility.configure do |config|
  config.host = 'localhost'
  config.port = 8089
  config.username = 'admin'
  config.password = 'admin'
  config.https = false
end
```

This can be included in a script (after including ArchivesSpaceApiUtility).

If you're working in Rails, you can just create a file called `archivesspace_config.rb` in `/config/initializers` and put the configuration in there.

To configure the gem to use ENV vars, make sure this is in your application.rb file:

```
ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}
```

Then create /config/initializers/archivesspace_config.rb that looks like this:

```
ArchivesSpaceApiUtility.configure do |config|
  config.host = ENV['archivesspace_host']
  config.port = ENV['archivesspace_port'].to_i
  config.username = ENV['archivesspace_username']
  config.password = ENV['archivesspace_password']
  config.https = ENV['archivesspace_https']
end
```

Then specify environment-specific options in application.yml, for example:

```
defaults: &defaults

development:
  <<: *defaults
  archivesspace_host: localhost
  archivesspace_port: '8089'
  archivesspace_username: admin
  archivesspace_password: admin
  archivesspace_https: false

production:
  <<: *defaults
  archivesspace_host: your.production.host.org
  archivesspace_port: '8089'
  archivesspace_username: admin
  archivesspace_password: admin
  archivesspace_https: false

```


## Usage

Include the module:

```
Include ArchivesSpaceApiUtility
```

Start a session (aasigned to a variable for re-use):

```
session = ArchivesSpaceSession.new
```

Then use `get` or `post` to do what you need to do...

### get(*path,params={},headers={}*)

* **path** - See [ArchivesSpace API documentation](http://archivesspace.github.io/archivesspace/doc/file.API.html) for available paths for GET
* **params** - optional query params (to append to URL)
* **headers** - optional HTTP Request headers

Make a GET request:

    response = session.get('/repositories')

That returns a [NET::HTTPResponse](http://www.ruby-doc.org/stdlib-2.1.1/libdoc/net/http/rdoc/Net/HTTPResponse.html) object:

```
#<Net::HTTPOK 200 OK readbody=true>
```

To get the response body (a JSON object) just do:

```
response.body
 ```

And if you want that as a hash just use Ruby's JSON library

```
JSON.parse(response.body)
 ```

### post(*path,data,headers={}*)

* **path** - See [ArchivesSpace API documentation](http://archivesspace.github.io/archivesspace/doc/file.API.html) for available paths for POST
* **data** - Data to be sent in request body. This will be sent as a JSON object (you can pass in a hash and it will be converted to JSON before the request is made). The content and validity of your post data is between you and ArchivesSpace - if there is a problem the API should return a response explaining what the problem was. A bit of guidance can be found by looking at the JSON schema documents [here](https://github.com/hudmol/archivesspace/tree/master/common/schemas).
* **headers** - optional HTTP Request headers

Just like `get`, `post` will return a [NET::HTTPResponse](http://www.ruby-doc.org/stdlib-2.1.1/libdoc/net/http/rdoc/Net/HTTPResponse.html) object.

## License

See MIT-LICENSE
