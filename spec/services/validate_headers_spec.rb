require "rails_helper"

describe ValidateHeaders do
  describe "#call" do
    context "some header is nil" do
      let(:headers) { ["height", nil] }
      let(:spreadsheet) { double(:spreadsheet, headers: headers)}
      it "is false" do
        expect(ValidateHeaders.new(spreadsheet).call).to be false
      end
    end

    context "some header contains the char . $ # [ ] or /" do
      let(:headers) { ["lat.lower", "lat.upper"] }
      let(:spreadsheet) { double(:spreadsheet, headers: headers)}
      it "is false" do
        expect(ValidateHeaders.new(spreadsheet).call).to be false
      end
    end

    context "the headers are valid" do
      let(:headers) { ["name", "age", "weight"] }
      let(:spreadsheet) { double(:spreadsheet, headers: headers)}
      it "is true" do
        expect(ValidateHeaders.new(spreadsheet).call).to be true
      end
    end
  end
end
