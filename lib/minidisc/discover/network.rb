require "timeout"

module MiniDisc

  class Discover

    module Network

      DEFAULT_TIMEOUT_LIMIT = 2

      extend self

      # @param [String] service_type with protocol eg "_telnet._tcp"
      # @param [Hash] options
      # @option options [Integer] :timeout Timeout in seconds
      # @return [Array<Hash>]
      def services_with_timeout(service_type, options = {}, &block)
        timeout = options[:timeout] || DEFAULT_TIMEOUT_LIMIT
        Timeout::timeout(timeout) { services(service_type, &block) }
      rescue Timeout::Error => e
        return_empty
      end

      # @param [String] service_type with protocol eg "_telnet._tcp"
      # @return [Array<Hash>]
      def services(service_type, &block)
        Thread.abort_on_exception = true
        replies = {}
        DNSSD.browse!(service_type) do |reply|
          replies[reply.name] = reply
          if !reply.flags.more_coming?
            available_replies = replies.select do |_, service|
              service.flags.add?
            end
            return available_replies.map do |_, service|
              resolve = service.resolve
              {
                name: service.name,
                target: resolve.target,
                port: resolve.port
              }
            end
          end

        end
      rescue Errno::EBADF, DNSSD::ServiceNotRunningError
        return_empty
      end

      private

      def return_empty
        services = []
        yield(services) if block_given?
        services
      end

    end

  end

end
