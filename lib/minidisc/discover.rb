require "minidisc/discover/network"

module MiniDisc

  class Discover

    class << self

      def services(service_type, options = {}, &block)
        ensure_initialized(options)
        service_type = ServiceType.sym_to_dnnsd_string(service_type, options)
        discover(service_type, options, &block)
        @destinations
      end

      private

      def ensure_initialized(options)
        @logger ||= options[:logger] || Logger.new(STDOUT)
        @destinations ||= []
      end

      def discover(service_type, options = {}, &block)
        @destinations = if options[:override].nil?
          from_discovery(service_type, id: options[:id], timeout: options[:timeout], &block)
        else
          from_override(options[:override], &block)
        end
      end

      def from_override(services, &block)
        i = 0;
        service_objects = services.map do |service|
          Service.new("override_#{i += 1}", service[:host], port: service[:port])
        end
        @logger.info("Destinations: Overriding discovery with #{services.count} services")
        yield(service_objects) if block_given?
        service_objects
      end

      def match?(match_on, service_name)
        match_on.kind_of?(Regex) && service_name.match(match_on) ||
          match_on == service_name
      end

      def from_discovery(service_type, options = {}, &block)
        services = Network.services_with_timeout(service_type, timeout: options[:timeout])
        unless options[:id].nil?
          services.select! do |service|
            match?(options[:id], service[:name])
          end
        end
        service_objects = service_hashes_to_service_objects(services)
        @logger.info("Destinations: Discovered #{services.count} services")
        yield(service_objects) if block_given?
        service_objects
      end

      def service_hashes_to_service_objects(services)
        services.map do |service|
          Service.new(service[:name], service[:target], port: service[:port])
        end
      end

    end

    class Service

      include Comparable

      attr_reader :id, :host, :port

      def initialize(id, host, options = {})
        @id = id
        @host = host
        @port = options.fetch(:port, 8080)
      end

      def <=>(other)
        to_h <=> other.to_h
      end

      def to_h
        {
          id: @id,
          host: @host,
          port: @port
        }
      end

    end

  end

end
