require "rails_helper"

describe OpenFile do
  let(:planets_csv) do
    fixture_file_upload(
      "/files/planets.csv",
      "text/csv"
      )
  end

  let(:plants_zip) do
    fixture_file_upload(
      "/files/plants.zip",
      "application/zip, application/x-compressed-zip"
      )
  end

  describe "#call" do
    context "the filetype is one of csv, xls, xlsx" do
      it "returns an object that responds to row and last_row" do
        opened_file = OpenFile.new(planets_csv).call

        expect(opened_file).to respond_to(:row)
        expect(opened_file).to respond_to(:last_row)
      end
    end

    context "the filetype isn't accepted" do
      it "raises an error" do
        expect {
          OpenFile.new(plants_zip).call
        }.to raise_error("Invalid file type: .zip.")
      end
    end
  end
end
