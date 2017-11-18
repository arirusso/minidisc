require "helper"

describe MiniDisc::Discover::Network do
  describe "services_with_timeout" do
    let!(:start_time) { Time.now }
    before(:each) do
      block = ->(protocol) do
        loop {}
        :done
      end
      expect(MiniDisc::Discover::Network).to(receive(:services, &block))
      @result = MiniDisc::Discover::Network.services_with_timeout(:http)
    end

    it "times out and returns empty array" do
      expect(@result).to_not(eql(:done))
      expect(@result).to(eql([]))
    end
  end
end
