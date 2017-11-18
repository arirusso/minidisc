require "timeout"

module MiniDisc

  class Discover

    module Network

      DEFAULT_TIMEOUT_LIMIT = 2

      extend self

      # @param [Hash] options
      # @option options [Integer] :timeout Timeout in seconds
      # @return [Array<Hash>]
      def services_with_timeout(options = {})
        timeout = options.fetch(:timeout, DEFAULT_TIMEOUT_LIMIT)
        Timeout::timeout(timeout) { services }
      rescue Timeout::Error => e
        []
      end

      # @return [Array<Hash>]
      def services
        Thread.abort_on_exception = true
        replies = {}

        DNSSD.browse!(@protocol) do |reply|
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
        []
      end

    end

  end

end
