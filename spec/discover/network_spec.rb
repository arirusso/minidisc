require "helper"

describe MiniDisc::Discover::Network do
  describe "services_with_timeout" do
    let!(:start_time) { Time.now }
    let(:block) do
      ->(service_type) do
        loop {}
        :done
      end
    end

    before do
      expect(MiniDisc::Discover::Network).to(receive(:services, &block))
    end

    context "with block" do

      before do
        MiniDisc::Discover::Network.services_with_timeout(:http) do |result|
          @result = result
        end
      end

      it "times out and returns empty array" do
        expect(@result).to_not(eql(:done))
        expect(@result).to(be_kind_of(Array))
        expect(@result).to(be_empty)
      end

    end

    context "without block" do

      before do
        @result = MiniDisc::Discover::Network.services_with_timeout(:http)
      end

      it "times out and returns empty array" do
        expect(@result).to_not(eql(:done))
        expect(@result).to(be_kind_of(Array))
        expect(@result).to(be_empty)
      end

    end
  end
end
