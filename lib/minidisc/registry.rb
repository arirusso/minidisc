module MiniDisc

  module Registry

    # Register a service
    # @param [Integer] port
    # @return [Discovery]
    def self.add(protocol, port, options = {})
      ensure_logger
      @services ||= []
      service = Registry::Service.new(protocol, port, options = {})
      service.register(logger: @logger)
      @services << service
      service
    end

    private

    def ensure_logger(options = {})
      if @logger.nil?
        logfile = File.join("log", "registry.log")
        @logger = options[:logger] || $> #Logger.new(logfile)
      end
    end

    class Service

      attr_reader :id, :logger, :port

      # @param [Integer] port
      def initialize(protocol, port, options = {})
        @id = options[:id] || object_id.to_s
        @port = port
        @protocol = Protocol.find(protocol)
      end

      # register this service
      # @return [Boolean]
      def register(options = {})
        DNSSD.register(@id, @protocol, nil, @port) do
          properties = "id=#{@id} port=#{@port} protocol=#{@protocol}"
          unless options[:logger].nil?
            options[:logger].puts("MiniDisc::Registry::Service#register: #{properties}")
          end
        end
        true
      end

    end

  end
end
