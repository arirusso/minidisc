require "helper"

describe MiniDisc::ServiceType do
  describe "#sym_to_dnnsd_string" do
    context "without protocol" do
      let(:input) { :http }
      let(:result) { MiniDisc::ServiceType.sym_to_dnnsd_string(:http) }

      it "has the correct service type part and tcp as defult protocol part" do
        expect(result).to(eq("_http._tcp"))
      end

    end

    context "with protocol" do
      let(:input) { :example }
      let(:protocol) { :udp }
      let(:result) { MiniDisc::ServiceType.sym_to_dnnsd_string(input, protocol: protocol) }

      it "reflects when udp is passed in" do
        expect(result).to(eq("_example._udp"))
      end

    end

  end
end
