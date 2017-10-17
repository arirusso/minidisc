require "yaml"

module MiniDisc

  class Destination

    module Discover

      class Override

        CONFIG_FILE = File.join("config", "override_discover.yml").freeze

        attr_reader :services

        def initialize
          populate
        end

        def exists?
          !@services.nil?
        end

        private

        def populate
          services = YAML.load_file(CONFIG_FILE).freeze
          @services = services if services
        rescue Errno::ENOENT, Errno::EBADF
        end

      end

    end

  end

end
