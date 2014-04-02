**WORK IN PROGRES - DO NOT USE THIS YET**

## ArchivesSpace API Utility

A Ruby gem to facilitate interaction with the [ArchivesSpace](http://archivesspace.org/) REST API. Provides basic functionality for establishing and maintaining a session and performing GET and POST operations (using Ruby's Net::HTTP library).

For a more robust alternative, try Mark Cooper's [archivespace-client](https://github.com/mark-cooper/archivesspace-client]).

Documentation on the ArchivesSpace API can be found at [http://archivesspace.github.io/archivesspace/doc/file.API.html].

## Installation

Add this line to your application's Gemfile:

    gem 'archivesspace-api-utility', :git => "https://github.com/trevorthornton/archivesspace-api-utility.git"

And then execute:

    bundle install

Or pull the repository and install it yourself:

    gem build archivesspace-api-utility.gemspec
    gem install archivesspace-api-utility-VERSION.gem

## Configuration

This gem requires an instance of ArchivesSpace to be running on an accessible server. To tell your Rails app where that is, create a file called `archivesspace_config.rb` in `/config/initializers` and put this in it:

```
# Be sure to restart your server when you modify this file.

ArchivesSpaceApiUtility.configure do |config|
  config.host = 'localhost'
  config.port = 8089
  config.username = 'admin'
  config.password = 'admin'
  config.https = false
end
```

Then modify the configuration variables as appropriate.

## Usage

Eastablish a connection:

```
```

Make a GET request:

```
```

Send data in a POST:

```
```


## License

See MIT-LICENSE