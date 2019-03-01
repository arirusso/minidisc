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

    def self.ensure_logger(options = {})
      @logger ||= options[:logger] || Logger.new(STDOUT)
    end

    class Service

      attr_reader :id, :logger, :port

      # @param [Symbol] service_type eg :telnet
      # @param [Integer] port
      def initialize(service_type, port, options = {})
        @id = options.fetch(:id, object_id.to_s)
        @port = port
        @service_type = ServiceType.sym_to_dnnsd_string(service_type, options)
      end

      def registered?
        @registered
      end

      # Register this service
      # @return [Boolean]
      def register(options = {})
        DNSSD.register(@id, @service_type, nil, @port) do
          properties = "id=#{@id} port=#{@port} service_type=#{@service_type}"
          unless options[:logger].nil?
            options[:logger].info("MiniDisc::Registry::Service#register: #{properties}")
          end
        end
        @registered = true
      rescue Errno::EBADF
        @registered = false
      end

    end

  end
end
