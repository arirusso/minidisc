require "helper"

describe MiniDisc::Registry do
  let(:id) { "test-1"}
  let(:port) { 4040 }
  let(:service_type) { :http }

  describe ".add" do
    describe "with id specified" do
      let(:discovery) { MiniDisc::Registry.add(service_type, port, id: id) }

      it "populates" do
        expect(discovery.id).to_not(be_nil)
        expect(discovery.port).to_not(be_nil)
      end

      it "has correct values" do
        expect(discovery.id).to(eq(id))
        expect(discovery.port).to(eq(port))
      end
    end

    describe "with id not specified" do
      let(:discovery) { MiniDisc::Registry.add(service_type, port) }

      it "populates" do
        expect(discovery.id).to_not(be_nil)
        expect(discovery.port).to_not(be_nil)
      end

      it "has correct values" do
        expect(discovery.id).to(include(discovery.object_id.to_s))
        expect(discovery.port).to(eq(port))
      end
    end
  end

  describe "Service" do
    describe "#initialize" do
      describe "with id specified" do
        let(:discovery) { MiniDisc::Registry::Service.new(service_type, port, id: id) }

        it "populates" do
          expect(discovery.id).to_not(be_nil)
          expect(discovery.port).to_not(be_nil)
        end

        it "has correct values" do
          expect(discovery.id).to(eq(id))
          expect(discovery.port).to(eq(port))
        end
      end

      describe "with id not specified" do
        let(:discovery) { MiniDisc::Registry::Service.new(service_type, port) }

        it "populates" do
          expect(discovery.id).to_not(be_nil)
          expect(discovery.port).to_not(be_nil)
        end

        it "has correct values" do
          expect(discovery.id).to(include(discovery.object_id.to_s))
          expect(discovery.port).to(eq(port))
        end
      end
    end

    describe "#register" do
      let(:discovery) { MiniDisc::Registry::Service.new(service_type, port) }
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
end
