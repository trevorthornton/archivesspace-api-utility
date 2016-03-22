require 'net/http'
require 'json'
require 'uri'

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
      uri = URI("#{base_uri}/users/#{ArchivesSpaceApiUtility.configuration.username}/login")

      response = Net::HTTP.post_form(uri, 'password' => ArchivesSpaceApiUtility.configuration.password)
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

      # % needs to be replaced with entities or else the post will fail
      # anything that look like a real JS escapes will not be replaced
      data.gsub!(/\%(?![A-Za-z\d]{2})/, '&#37;')

      headers.merge!(@auth_header)
      Net::HTTP.start(ArchivesSpaceApiUtility.configuration.host, ArchivesSpaceApiUtility.configuration.port) do |http|
        http.read_timeout = 120
        http.post(path, data, headers)
      end
    end

    def get(path,params={},headers={})
      # verify that path starts with /
      if !path.match(/^\//)
        path = '/' + path
      end

      uri = URI(base_uri)
      uri.path = path
      uri.query = URI.encode_www_form(fix_params(params))

      request = Net::HTTP::Get.new(uri)
      headers.merge!(@auth_header)
      headers.each { |k,v| request[k] = v }
      Net::HTTP.start(ArchivesSpaceApiUtility.configuration.host, ArchivesSpaceApiUtility.configuration.port) do |http|
        http.request(request)
      end
    end

    def delete(path,params={},headers={})
      # verify that path starts with /
      if !path.match(/^\//)
        path = '/' + path
      end

      uri = URI(base_uri)
      uri.path = path
      uri.query = URI.encode_www_form(fix_params(params))

      request = Net::HTTP::Delete.new(uri)
      headers.merge!(@auth_header)
      headers.each { |k,v| request[k] = v }
      Net::HTTP.start(ArchivesSpaceApiUtility.configuration.host, ArchivesSpaceApiUtility.configuration.port) do |http|
        http.request(request)
      end
    end

    # The ArchivesSpace API is particular about how multi-valued parameters (arrays) are included in GET params
    # This is cool: ?resolved[]=value1&resolved[]=value2
    # This is not: ?resolved=value1&resolved=value2
    # ...but that's how Ruby URI wants to do it, so we to trick it into doing it the other way.
    # Check out find_opts in the ASpace frontend ApplicationController to see how they handle this for 'resolve' only
    def fix_params(params)
      query_params = {}
      params.each do |k,v|
        case v
        when Array
          query_params["#{k.to_s}[]"] = v
        when Hash
          v.each do |kk,vv|
            query_params["#{k.to_s}[#{kk.to_s}]"] = vv
          end
        else
          query_params[k.to_s] = v
        end
      end
      query_params
    end

  end


end
