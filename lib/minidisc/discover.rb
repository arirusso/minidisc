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

      def all(options = {})
        ensure_initialized(options)
        @destinations
      end

      private

      def ensure_initialized(options = {})
        @logger ||= options[:logger] || $>
        @destinations ||= []
        populate(options)
      end

      def populate(options = {})
        @destinations = if options[:override].nil?
          from_discovery
        else
          from_override(options[:override])
        end
      end

      def from_override(services)
        i = 0;
        services = services.map do |service|
          new("override_#{i += 1}", service[:host], port: service[:port])
        end
        @logger.puts("Destinations: Overriding discovery with #{services.count} services")
        services
      end

      def from_discovery(options = {})
        services = Network.services_with_timeout
        unless options[:match].nil?
          services.select! do |service|
            service[:name].match(options[:match])
          end
        end
        services = services.map do |service|
          new(service[:name], service[:target], port: service[:port])
        end
        @logger.puts("Destinations: Discovered #{services.count} services")
        services
      end

    end

  end

end
