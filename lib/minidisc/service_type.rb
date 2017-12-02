module MiniDisc

  module ServiceType

    def self.to_dnssd_service_type(service_type, options = {})
      protocol = options.fetch(:protocol, :tcp).to_s
      protocol.gsub!(/\_/, "-")
      "_#{service_type}._#{protocol}"
    end

  end

end
