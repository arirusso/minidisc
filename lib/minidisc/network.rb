module MiniDisc
  module Network

    extend self

    def add(*a, &block)
      Registry.add(*a, &block)
    end

    def find_all(*a, &block)
      Discover.services(*a, &block)
    end

  end
end
