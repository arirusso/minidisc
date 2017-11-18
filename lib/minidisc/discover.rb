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
        @destinations ||= []
        populate(options)
        @destinations
      end

      private

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
        puts "Destinations: Overriding discovery with #{services.count} services"
        services
      end

      def from_discovery
        services = Network.services_with_timeout
        services.select! do |service|
          service[:name].match(/d\-.+/)
        end
        services = services.map do |service|
          new(service[:name], service[:target], port: service[:port])
        end
        puts "Destinations: Discovered #{services.count} services"
        services
      end

    end

  end

end
