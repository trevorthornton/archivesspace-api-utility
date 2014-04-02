module ArchivesSpaceApiUtility

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :host, :port, :username, :password, :https

    def initialize
      @host = 'localhost'
      @port = 8089
      @username = 'admin'
      @password = 'admin'
      @https = false
    end

  end

end