require "rails_helper"

describe SendToFirebase do
  let(:planets) do
    [
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
    ]
  end

  let(:people) do
    [
      {
        "" => "ben",
        "age" => "25"
      },
      {
        "" => "andy",
        "age" => "23"
      }
    ]
  end

  let(:planets_spreadsheet) { double(:spreadsheet, to_a: planets) }
  let(:people_spreadsheet)  { double(:spreadsheet, to_a: people) }

  let(:planets_file) { double(:file, original_filename: "planets.csv") }
  let(:people_file)  { double(:file, original_filename: "invalid.csv") }

  let(:planets_params) do
    {
      file: planets_file,
      firebase_app_url: "https://test-app.firebaseio.com/"
    }
  end

  let(:people_params) do
    {
      file: people_file,
      firebase_app_url: "https://test-app.firebaseio.com/"
    }
  end

  describe "#call" do
    it "returns a response object that responds to success?" do
      VCR.use_cassette('planets_csv') do
        expect(
          SendToFirebase.new(planets_spreadsheet, planets_params).call
        ).to respond_to(:success?)
      end
    end

    context "the objects have nonempty keys" do
      it "is successful" do
        VCR.use_cassette('planets_csv') do
          response = SendToFirebase.new(planets_spreadsheet, planets_params).call

          expect(response.success?).to be true
        end
      end
    end

    context "one of the keys is empty" do
      it "is unsuccessful" do
        VCR.use_cassette('invalid_csv') do
          response = SendToFirebase.new(people_spreadsheet, people_params).call

          expect(response.success?).to be false
        end
      end
    end
  end
end
