require "helper"

describe MiniDisc::Network do
  describe ".add" do
    let(:port) { 4040 }
    let(:service_type) { :http }

    let(:args) do
      [kind_of(String), "_http._tcp", nil, port]
    end

    before(:each) do
      expect(DNSSD).to(receive(:register).with(*args).and_return(true))
    end

    it "registers a service" do
      service = MiniDisc::Network.add(service_type, port)
      expect(service.registered?).to(be(true))
    end

  end

  describe ".find_all" do

    context "from override file" do
      let(:host) { "something.local." }
      let(:port) { "80" }
      let(:config_service) do
        {
          host: host,
          port: port
        }
      end

      let(:destinations) do
         MiniDisc::Network.find_all(:http, override: [config_service])
      end

      it "populates" do
        expect(destinations).to_not(be_nil)
        expect(destinations).to_not(be_empty)
      end

      it "has correct data" do
        expect(destinations.count).to(eq(1))
        destination = destinations.first
        expect(destination).to(be_kind_of(MiniDisc::Discover::Service))
        expect(destination.id).to(eq("override_1"))
        expect(destination.host).to(eq(host))
        expect(destination.port).to(eq(port))
      end
    end

    context "from discovery" do
      let(:name) { "minidisc-test_service" }
      let(:host) { "testservice.local." }
      let(:port) { "8080" }
      let(:service) do
        {
          name: name,
          target: host,
          port: port
        }
      end

      before(:each) do
        expect(MiniDisc::Discover::Network).to(receive(:services_with_timeout).at_least(:once).and_return([service]))
      end

      context "with id matching" do
        let(:destinations) do
          MiniDisc::Network.find_all(:http, match: /minidisc\-.+/)
        end

        it "populates" do
          expect(destinations).to_not(be_nil)
          expect(destinations).to_not(be_empty)
        end

        it "has correct data" do
          expect(destinations.count).to(eq(1))
          destination = destinations.first
          expect(destination).to(be_kind_of(MiniDisc::Discover::Service))
          expect(destination.id).to(eq(name))
          expect(destination.host).to(eq(host))
          expect(destination.port).to(eq(port))
        end
      end

      context "without id matching" do
        let(:destinations) { MiniDisc::Discover.services(:http) }

        it "populates" do
          expect(destinations).to_not(be_nil)
          expect(destinations).to_not(be_empty)
        end

        it "has correct data" do
          expect(destinations.count).to(eq(1))
          destination = destinations.first
          expect(destination).to(be_kind_of(MiniDisc::Discover::Service))
          expect(destination.id).to(eq(name))
          expect(destination.host).to(eq(host))
          expect(destination.port).to(eq(port))
        end
      end
    end
  end
end
