module MiniDisc

  class Discover

    module Network

      def initialize(protocol)
        @protocol = protocol
      end

      def services_with_timeout
        Timeout::timeout(2) { services }
      rescue Timeout::Error => e
        []
      end

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
