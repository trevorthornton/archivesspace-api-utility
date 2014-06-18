require 'net/http'
require 'json'
require 'uri'
require 'typhoeus'

require 'archivesspace-api-utility/configuration'

module ArchivesSpaceApiUtility
  
  class ArchivesSpaceSession

    attr_reader :session_token, :base_uri

    def initialize(options={})
      if options[:session_token]
        @session_token = options[:session_token]
        @auth_header = { 'X-ArchivesSpace-session' => @session_token }
      else
        connect
      end
    end

    def connect
      response = request_response("#{base_uri}/users/#{ArchivesSpaceApiUtility.configuration.username}/login",
        method: :post, body: { password: ArchivesSpaceApiUtility.configuration.password })
      @session_token = JSON.parse(response.body)['session']
      @auth_header = { 'X-ArchivesSpace-session' => @session_token }
    end

    def reconnect
      connect
    end

    def base_uri
      schema = ArchivesSpaceApiUtility.configuration.https ? 'https' : 'http'
      "#{schema}://#{ArchivesSpaceApiUtility.configuration.host}:#{ArchivesSpaceApiUtility.configuration.port}"
    end

    def post(path,data={},headers={})    
      if data.kind_of?(Hash)
        data = JSON.generate(data)
      end
      headers.merge!(@auth_header)
      response = request_response("#{base_uri}#{verify_path(path)}", method: :post, body: data, headers: headers)
    end

    def get(path,params={},headers={})
      headers.merge!(@auth_header)
      request_response("#{base_uri}#{verify_path(path)}", method: :get, params: params, headers: headers)
    end

    # verify that path starts with / and fix if it doesn't
    def verify_path(path)
      if !path.match(/^\//)
        path.prepend '/'
      end
      path
    end

    def request_response(url, options={})
      request = Typhoeus::Request.new(url, options)
      request.run
      request.response
    end

  end

end