module MiniDisc

  class Discovery

    attr_reader :id, :logger, :port

    # Announce this service
    # @param [Integer] port
    # @return [Discovery]
    def self.announce(port)
      discovery = new(port)
      discovery.announce
      discovery
    end

    # @param [Integer] port
    def initialize(protocol, port)
      @id = build_id
      @port = port
      @protocol = protocol
      populate_logger
    end

    # Announce this service
    # @return [Boolean]
    def announce
      DNSSD.register(@id, @protocol, nil, @port) do
        properties = "id=#{@id} port=#{@port} protocol=#{@protocol}"
        @logger.info("MiniDisc::Discovery#announce: #{properties}")
      end
      true
    end

    private

    def build_id
      "b-#{object_id}"
    end

    def populate_logger
      logfile = File.join("log", "discovery.log")
      @logger = $> #Logger.new(logfile)
    end

  end

end
