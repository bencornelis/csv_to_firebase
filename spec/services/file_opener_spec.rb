require "rails_helper"

describe FileOpener do
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

  let(:invalid_csv) do
    fixture_file_upload(
      "/files/invalid.csv",
      "text/csv"
      )
  end

  let(:planets_csv_opener) do
    FileOpener.new(planets_csv)
  end

  let(:plants_zip_opener) do
    FileOpener.new(plants_zip)
  end

  describe "#open_file" do
    context "the filetype is one of csv, xls, xlsx" do
      it "returns an object that responds to row and last_row" do
        expect(planets_csv_opener.open_file).to respond_to(:row)
        expect(planets_csv_opener.open_file).to respond_to(:last_row)
      end
    end

    context "the filetype isn't one of those" do
      it "raises an error" do
        expect {
          plants_zip_opener.open_file
        }.to raise_error("Invalid file type: .zip.")
      end
    end
  end
end
