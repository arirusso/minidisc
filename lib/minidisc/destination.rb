require "minidisc/destination/discover"

module MiniDisc

  class Destination

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

      def all
        @destinations ||= []
        populate
        @destinations
      end

      private

      def populate
        @override = Discover::Override.new
        @destinations = if @override.exists?
          from_config
        else
          from_discovery
        end
      end

      def from_config
        i = 0;
        services = @override.services.map do |service|
          new("override_#{i += 1}", service[:host], port: service[:port])
        end
        puts "Destinations: Overriding discovery with #{services.count} services"
        services
      end

      def from_discovery
        services = Discover.services_with_timeout
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
