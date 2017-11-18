require "helper"

describe MiniDisc::Discovery do
  let!(:port) { 4040 }
  let!(:protocol) { :http }
  let(:discovery) { MiniDisc::Discovery.new(protocol, port) }

  context "#initialize" do
    it "populates" do
      expect(discovery.id).to_not(be_nil)
      expect(discovery.logger).to_not(be_nil)
      expect(discovery.port).to_not(be_nil)
    end

    it "has correct values" do
      expect(discovery.id).to(include(discovery.object_id.to_s))
      #expect(@discovery.logger).to(be_kind_of(Logger))
      expect(discovery.port).to(eq(port))
    end
  end

  context "#announce" do
    let(:args) do
      [discovery.id, MiniDisc::Protocol.find(protocol), nil, port]
    end

    before(:each) do
      expect(DNSSD).to(receive(:register).with(*args).and_return(true))
    end

    it "announces and returns true" do
      expect(discovery.announce).to(be(true))
    end
  end

end
