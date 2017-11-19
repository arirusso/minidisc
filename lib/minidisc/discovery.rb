module MiniDisc

  class Discovery

    attr_reader :id, :logger, :port

    # register this service
    # @param [Integer] port
    # @return [Discovery]
    def self.register(protocol, port, options = {})
      discovery = new(protocol, port, options = {})
      discovery.register
      discovery
    end

    # @param [Integer] port
    def initialize(protocol, port, options = {})
      @id = options[:id] || object_id.to_s
      @port = port
      @protocol = Protocol.find(protocol)
      populate_logger(options)
    end

    # register this service
    # @return [Boolean]
    def register
      DNSSD.register(@id, @protocol, nil, @port) do
        properties = "id=#{@id} port=#{@port} protocol=#{@protocol}"
        @logger.puts("MiniDisc::Discovery#register: #{properties}")
      end
      true
    end

    private

    def populate_logger(options = {})
      logfile = File.join("log", "discovery.log")
      @logger = options[:logger] || $> #Logger.new(logfile)
    end

  end

end
