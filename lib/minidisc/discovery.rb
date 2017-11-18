module MiniDisc

  class Discovery

    attr_reader :id, :logger, :port

    # Announce this service
    # @param [Integer] port
    # @return [Discovery]
    def self.announce(protocol, port, options = {})
      discovery = new(protocol, port, options = {})
      discovery.announce
      discovery
    end

    # @param [Integer] port
    def initialize(protocol, port, options = {})
      @id = options[:id] || object_id.to_s
      @port = port
      @protocol = Protocol.find(protocol)
      populate_logger(options)
    end

    # Announce this service
    # @return [Boolean]
    def announce
      DNSSD.register(@id, @protocol, nil, @port) do
        properties = "id=#{@id} port=#{@port} protocol=#{@protocol}"
        @logger.puts("MiniDisc::Discovery#announce: #{properties}")
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
