require "helper"

describe MiniDisc::Registry do
  let!(:port) { 4040 }
  let!(:service_type) { :http }
  let(:discovery) { MiniDisc::Registry::Service.new(service_type, port) }

  describe "#initialize" do
    it "populates" do
      expect(discovery.id).to_not(be_nil)
      expect(discovery.port).to_not(be_nil)
    end

    it "has correct values" do
      expect(discovery.id).to(include(discovery.object_id.to_s))
      expect(discovery.port).to(eq(port))
    end
  end

  describe "#register" do
    let(:args) do
      [discovery.id, "_http._tcp", nil, port]
    end

    before(:each) do
      expect(DNSSD).to(receive(:register).with(*args).and_return(true))
    end

    it "registers and returns true" do
      expect(discovery.register).to(be(true))
    end
  end

end
