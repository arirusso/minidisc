require "minidisc/discover/network"

module MiniDisc

  class Discover

    attr_reader :id, :host, :port

    def initialize(id, host, options = {})
      @id = id
      @host = host
      @port = options.fetch(:port, 8080)
    end

    def to_h
      {
        id: @id,
        host: @host,
        port: @port
      }
    end

    class << self

      def services(service_type, options = {}, &block)
        ensure_initialized(options)
        discover(service_type, options, &block)
        @destinations
      end

      private

      def ensure_initialized(options)
        @logger ||= options[:logger] || $>
        @destinations ||= []
      end

      def discover(service_type, options = {}, &block)
        @destinations = if options[:override].nil?
          from_discovery(service_type, &block)
        else
          from_override(options[:override], &block)
        end
      end

      def from_override(services, &block)
        i = 0;
        services = services.map do |service|
          new("override_#{i += 1}", service[:host], port: service[:port])
        end
        @logger.puts("Destinations: Overriding discovery with #{services.count} services")
        yield(services) if block_given?
        services
      end

      def match?(match_on, service_name)
        match_on.kind_of?(Regex) && service_name.match(match_on) ||
          match_on == service_name
      end

      def from_discovery(service_type, options = {}, &block)
        services = Network.services_with_timeout(service_type)
        unless options[:id].nil?
          services.select! do |service|
            match?(options[:id], service[:name])
          end
        end
        services = services.map do |service|
          new(service[:name], service[:target], port: service[:port])
        end
        @logger.puts("Destinations: Discovered #{services.count} services")
        yield(services) if block_given?
        services
      end

    end

  end

end
