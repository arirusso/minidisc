require "helper"

describe MiniDisc::Discover do
  describe ".all" do

    context "from override file" do
      let!(:host) { "something.local." }
      let!(:port) { "80" }
      let!(:config_service) do
        {
          host: host,
          port: port
        }
      end

      let(:destinations) do
         MiniDisc::Discover.all(override: [config_service])
      end

      it "populates" do
        expect(destinations).to_not(be_nil)
        expect(destinations).to_not(be_empty)
      end

      it "has correct data" do
        expect(destinations.count).to(eq(1))
        destination = destinations.first
        expect(destination).to(be_kind_of(MiniDisc::Discover))
        expect(destination.id).to(eq("override_1"))
        expect(destination.host).to(eq(host))
        expect(destination.port).to(eq(port))
      end
    end

    context "from discovery" do
      let!(:name) { "minidisc-test_service" }
      let!(:host) { "testservice.local." }
      let!(:port) { "8080" }
      let!(:service) do
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
          MiniDisc::Discover.all(match: /minidisc\-.+/)
        end

        it "populates" do
          expect(destinations).to_not(be_nil)
          expect(destinations).to_not(be_empty)
        end

        it "has correct data" do
          expect(destinations.count).to(eq(1))
          destination = destinations.first
          expect(destination).to(be_kind_of(MiniDisc::Discover))
          expect(destination.id).to(eq(name))
          expect(destination.host).to(eq(host))
          expect(destination.port).to(eq(port))
        end
      end

      context "without id matching" do
        let(:destinations) { MiniDisc::Discover.all }

        it "populates" do
          expect(destinations).to_not(be_nil)
          expect(destinations).to_not(be_empty)
        end

        it "has correct data" do
          expect(destinations.count).to(eq(1))
          destination = destinations.first
          expect(destination).to(be_kind_of(MiniDisc::Discover))
          expect(destination.id).to(eq(name))
          expect(destination.host).to(eq(host))
          expect(destination.port).to(eq(port))
        end
      end
    end
  end

  describe "#to_h" do
    let!(:id) { "minidisc-test" }
    let!(:host) { "test.local." }
    let!(:port) { 8000 }
    let!(:destination) do
      MiniDisc::Discover.new(id, host, port: port)
    end
    let(:hash) { destination.to_h }

    it "converts to hash" do
      expect(hash).to_not(be_nil)
      expect(hash).to(be_kind_of(Hash))
      expect(hash[:id]).to_not(be_nil)
      expect(hash[:host]).to_not(be_nil)
      expect(hash[:port]).to_not(be_nil)
    end

    it "matches object" do
      expect(hash[:id]).to(eq(destination.id))
      expect(hash[:host]).to(eq(destination.host))
      expect(hash[:port]).to(eq(destination.port))
    end

    it "has correct data" do
      expect(hash[:id]).to(eq(id))
      expect(hash[:host]).to(eq(host))
      expect(hash[:port]).to(eq(port))
    end
  end
end
