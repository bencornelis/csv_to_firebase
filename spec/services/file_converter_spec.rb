require "rails_helper"

describe FileConverter do
  let(:planets_csv) do
    fixture_file_upload(
      "/files/planets.csv",
      "text/csv"
      )
  end

  let(:planets_csv_opener) do
    FileOpener.new(planets_csv)
  end

  let(:planets_csv_converter) do
    FileConverter.new(planets_csv_opener.open_file)
  end

  it "raises an error if its argument is nil" do
    expect {
      FileConverter.new(nil)
    }.to raise_error("No file to convert!")
  end

  describe "#convert" do
    it "converts the file into an array of hashes" do
      expect(planets_csv_converter.convert).to eq([
        {
          "name" => "earth",
          "radius" => "6378"
        },
        {
          "name" => "mars",
          "radius" => "3397"
        },
        {
          "name" => "jupiter",
          "radius" => "71492"
        }
      ])
    end
  end

  describe "#metadata" do
    it "gets the headers and number of rows" do
      expect(planets_csv_converter.metadata).to eq({
        column_headers: ["name", "radius"],
        rows_count: 3
      })
    end
  end
end
