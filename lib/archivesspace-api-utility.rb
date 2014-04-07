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
      # verify that path starts with /
      if !path.match(/^\//)
        path = '/' + path
      end

      # NOTE: Ruby's URI module generates multi-valued query parameters in the form "key=value1&key=value2"
      #   but the ASpace API only works if you send them like this: "key[]=value1&key[]=value2".
      #   So ideally the next part would look like this:
      #
      #   uri = URI(base_uri)
      #   uri.path = path
      #   uri.query = params_to_query(params)
      #
      # ... but it doesn't. Need to see if thins changes in future versions of ASpace.

      uri = "#{base_uri}#{path}"
      if !params.empty?
        uri += "?#{params_to_query(params)}"
      end
      uri = URI(uri)
      
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
      data_params.join(' ')
    end
    

    def params_to_query(params)
      queries = []
      
      query_param = lambda do |k,v|
        v = CGI.escape(v)
        return "#{k}=#{v}"
      end

      array_to_queries = Proc.new do |k, array|
        array.each { |v| queries << query_param.call("#{k}[]",v) }
      end

      key_value_to_queries = Proc.new do |k,v|
        case v
        when FalseClass
          queries << query_param.call("#{k}",0)
        when TrueClass
          queries << query_param.call("#{k}",1)
        when String
          queries << query_param.call("#{k}",v)
        when Array
          array_to_queries.call(k,v)
        when Hash
          v.each { |kk,vv| key_value_to_queries.call("#{k}[#{kk}]",vv)}
        end
      end

      params.each { |k,v| key_value_to_queries.call(k,v) }
      queries.join('&')
    end

  end


end