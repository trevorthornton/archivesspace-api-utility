require 'net/http'
require 'json'
require 'uri'

require 'archivesspace-api-utility/configuration'

module ArchivesSpaceApiUtility
  
  class ArchivesSpaceSession

    attr_reader :session_token, :base_uri

    def initialize
      connect
    end

    def connect
      uri = base_uri
      uri.path = "/users/#{ArchivesSpaceApiUtility.configuration.username}/login"
      response = Net::HTTP.post_form(uri, 'password' => ArchivesSpaceApiUtility.configuration.password)
      @session_token = JSON.parse(response.body)['session']
      @auth_header = { 'X-ArchivesSpace-session' => @session_token }
    end

    def reconnect
      connect
    end

    def base_uri
      schema = ArchivesSpaceApiUtility.configuration.https ? 'https' : 'http'
      URI("#{schema}://#{ArchivesSpaceApiUtility.configuration.host}:#{ArchivesSpaceApiUtility.configuration.port}")
    end

    def post(path,data,headers={})    
      if data.kind_of?(Hash)
        data = JSON.generate(data)
      end
      headers.merge!(@auth_header)
      Net::HTTP.start(ArchivesSpaceApiUtility.configuration.host, ArchivesSpaceApiUtility.configuration.port) do |http|
        http.post(path, data, headers)
      end
    end

    def get(path,params={},headers={})
      uri = base_uri
      uri.path = path
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new(uri)
      headers.merge!(@auth_header)
      headers.each { |k,v| request[k] = v }
      Net::HTTP.start(ArchivesSpaceApiUtility.configuration.host, ArchivesSpaceApiUtility.configuration.port) do |http|
        http.request(request)
      end
    end

    def params_to_data(params)
      data_params = []
      params.each { |k,v| data_params << "#{k}=#{v}"}
      data = data_params.join(' ')
    end
    
  end

end