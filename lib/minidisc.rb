require "dnssd"

require "minidisc/protocol"

require "minidisc/discover"
require "minidisc/discovery"

module MiniDisc

  VERSION = "0.0.1"

  module Network

    extend self

    def add(protocol, port, options = {})
      Discovery.accounce(protocol, port, options)
    end

    def find_all(protocol, options = {})
      Discover.services(protocol, options)
    end

  end

end
