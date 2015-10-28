require "rails_helper"

describe Spreadsheet do
  let(:planets_csv) do
    fixture_file_upload(
      "/files/planets.csv",
      "text/csv"
      )
  end

  let(:planets_csv_spreadsheet) do
    Spreadsheet.build(planets_csv)
  end

  describe ".build" do
    it "returns a new spreadsheet" do
      expect(planets_csv_spreadsheet).to be_a Spreadsheet
    end
  end

  describe "#to_a" do
    it "converts the spreadsheet to an array of hash objects" do
      expect(planets_csv_spreadsheet.to_a).to eq([
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

  describe "#headers" do
    it "pulls the headers from the spreadsheet" do
      expect(planets_csv_spreadsheet.headers).to eq(["name", "radius"])
    end
  end

  describe "#metadata" do
    it "returns the headers and row count" do
      expect(planets_csv_spreadsheet.metadata).to eq({
        headers: ["name", "radius"],
        rows_count: 3
      })
    end
  end
end
