module MiniDisc

  module ServiceType

    def self.sym_to_dnnsd_string(service_type, options = {})
      protocol = options.fetch(:protocol, :tcp).to_s
      protocol.gsub!(/\_/, "-")
      "_#{service_type}._#{protocol}"
    end

  end

end
