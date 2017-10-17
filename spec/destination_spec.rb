require "helper"

describe MiniDisc::Destination do

  context ".all" do

    context "from override file" do

      before(:each) do
        @host = "something.local."
        @port = "80"
        config_service = {
          host: @host,
          port: @port
        }
        expect_any_instance_of(MiniDisc::Destination::Discover::Override).to(receive(:services).at_least(:once).and_return([config_service]))
        expect_any_instance_of(MiniDisc::Destination::Discover::Override).to(receive(:exists?).at_least(:once).and_return(true))
        @destinations = MiniDisc::Destination.all
      end

      it "populates" do
        expect(@destinations).to_not(be_nil)
        expect(@destinations).to_not(be_empty)
      end

      it "has correct data" do
        expect(@destinations.count).to(eq(1))
        destination = @destinations.first
        expect(destination).to(be_kind_of(MiniDisc::Destination))
        expect(destination.id).to(eq("override_1"))
        expect(destination.host).to(eq(@host))
        expect(destination.port).to(eq(@port))
      end

    end

    context "from discovery" do

      before(:each) do
        @name = "d-test_service"
        @host = "testservice.local."
        @port = "8080"
        service = {
          name: @name,
          target: @host,
          port: @port
        }
        expect_any_instance_of(MiniDisc::Destination::Discover::Override).to(receive(:exists?).at_least(:once).and_return(false))
        expect(MiniDisc::Destination::Discover).to(receive(:services_with_timeout).at_least(:once).and_return([service]))
        @destinations = MiniDisc::Destination.all
      end

      it "populates" do
        expect(@destinations).to_not(be_nil)
        expect(@destinations).to_not(be_empty)
      end

      it "has correct data" do
        expect(@destinations.count).to(eq(1))
        destination = @destinations.first
        expect(destination).to(be_kind_of(MiniDisc::Destination))
        expect(destination.id).to(eq(@name))
        expect(destination.host).to(eq(@host))
        expect(destination.port).to(eq(@port))
      end

    end

  end

  context "#to_h" do

    before(:each) do
      @id = "d-test"
      @host = "test.local."
      @port = 8000
      @destination = MiniDisc::Destination.new(@id, @host, port: @port)
      @hash = @destination.to_h
    end

    it "converts to hash" do
      expect(@hash[:id]).to_not(be_nil)
      expect(@hash[:host]).to_not(be_nil)
      expect(@hash[:port]).to_not(be_nil)
    end

    it "matches object" do
      expect(@hash[:id]).to(eq(@destination.id))
      expect(@hash[:host]).to(eq(@destination.host))
      expect(@hash[:port]).to(eq(@destination.port))
    end

    it "has correct data" do
      expect(@hash[:id]).to(eq(@id))
      expect(@hash[:host]).to(eq(@host))
      expect(@hash[:port]).to(eq(@port))
    end

  end

end
