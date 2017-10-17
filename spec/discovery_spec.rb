require "helper"

describe MiniDisc::Discovery do

  before(:each) do
    @port = 4040
    @protocol = "_http._tcp"
    @discovery = MiniDisc::Discovery.new(@protocol, @port)
  end

  context "#initialize" do

    it "populates" do
      expect(@discovery.id).to_not(be_nil)
      expect(@discovery.logger).to_not(be_nil)
      expect(@discovery.port).to_not(be_nil)
    end

    it "has correct values" do
      expect(@discovery.id).to(include(@discovery.object_id.to_s))
      #expect(@discovery.logger).to(be_kind_of(Logger))
      expect(@discovery.port).to(eq(@port))
    end

  end

  context "#announce" do

    before(:each) do
      @args = [@discovery.id, @protocol, nil, @port]
      expect(DNSSD).to(receive(:register).with(*@args).and_return(true))
    end

    it "announces and returns true" do
      expect(@discovery.announce).to(be(true))
    end

  end

end
