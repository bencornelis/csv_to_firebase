require "rails_helper"

describe ValidateHeaders do

  let(:headers1) { ["name", "age", "weight"] }
  let(:headers2) { ["height", nil] }
  let(:headers3) { ["lat.lower", "lat.upper"] }

  describe "#call" do
    context "some header is nil" do
      it "is false" do
        expect(ValidateHeaders.new(headers2).call).to be false
      end
    end

    context "some header contains the char . $ # [ ] or /" do
      it "is false" do
        expect(ValidateHeaders.new(headers3).call).to be false
      end
    end

    context "the headers are valid" do
      it "is true" do
        expect(ValidateHeaders.new(headers1).call).to be true
      end
    end
  end
end
