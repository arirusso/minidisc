module MiniDisc

  module Protocol

    PROTOCOL = {
      http: "_http._tcp",
      telnet: "_telnet._tcp"
    }.freeze

    def self.find(key)
      PROTOCOL[key]
    end

  end

end
