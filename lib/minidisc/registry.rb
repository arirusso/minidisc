module MiniDisc

  module Registry

    # Register a service
    # @param [Integer] port
    # @return [Discovery]
    def self.add(service_type, port, options = {})
      ensure_logger
      @services ||= []
      service = Registry::Service.new(service_type, port, options = {})
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

      # @param [Symbol] service_type eg :telnet
      # @param [Integer] port
      def initialize(service_type, port, options = {})
        @id = options[:id] || object_id.to_s
        @port = port
        @service_type = ServiceType.find(service_type)
      end

      # register this service
      # @return [Boolean]
      def register(options = {})
        DNSSD.register(@id, @service_type, nil, @port) do
          properties = "id=#{@id} port=#{@port} service_type=#{@service_type}"
          unless options[:logger].nil?
            options[:logger].puts("MiniDisc::Registry::Service#register: #{properties}")
          end
        end
        true
      end

    end

  end
end
