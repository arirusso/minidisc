module MiniDisc

  module ServiceType

    TYPE = {
      http: "_http._tcp",
      telnet: "_telnet._tcp"
    }.freeze

    def self.find(key)
      TYPE[key]
    end

  end

end
