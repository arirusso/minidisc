require "timeout"

module MiniDisc

  class Discover

    module Network

      DEFAULT_TIMEOUT_LIMIT = 2

      extend self

      # @param [String] service_type eg "_telnet._tcp"
      # @param [Hash] options
      # @option options [Integer] :timeout Timeout in seconds
      # @return [Array<Hash>]
      def services_with_timeout(service_type, options = {}, &block)
        timeout = options.fetch(:timeout, DEFAULT_TIMEOUT_LIMIT)
        Timeout::timeout(timeout) { services(service_type, &block) }
      rescue Timeout::Error => e
        services = []
        yield(services) if block_given?
        services
      end

      # @param [String] service_type eg "_telnet._tcp"
      # @return [Array<Hash>]
      def services(service_type, &block)
        Thread.abort_on_exception = true
        replies = {}

        DNSSD.browse!(protocol) do |reply|
          replies[reply.name] = reply
          if !reply.flags.more_coming?
            available_replies = replies.select do |_, service|
              service.flags.add?
            end
            services = available_replies.map do |_, service|
              resolve = service.resolve
              {
                name: service.name,
                target: resolve.target,
                port: resolve.port
              }
            end
            yield(services) if block_given?
            services
          end

        end
      rescue Errno::EBADF, DNSSD::ServiceNotRunningError
        services = []
        yield(services) if block_given?
        services
      end

    end

  end

end
