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

  let(:planets_spreadsheet) { double("spreadsheet", to_a: planets) }
  let(:people_spreadsheet)  { double("spreadsheet", to_a: people) }

  let(:planets_params) do
    {
      spreadsheet:  planets_spreadsheet,
      firebase_app: "test-app",
      file_name:    "planets.csv"
    }
  end

  let(:people_params) do
    {
      spreadsheet:  people_spreadsheet,
      firebase_app: "test-app",
      file_name:    "invalid.csv"
    }
  end

  describe "#call" do
    it "returns a response object that responds to success?" do
      VCR.use_cassette('planets_csv') do
        expect(
          SendToFirebase.new(planets_params).call
        ).to respond_to(:success?)
      end
    end

    context "the objects have nonempty keys" do
      it "is successful" do
        VCR.use_cassette('planets_csv') do
          response = SendToFirebase.new(planets_params).call

          expect(response.success?).to be(true)
        end
      end
    end

    context "one of the keys is empty" do
      it "is unsuccessful" do
        VCR.use_cassette('invalid_csv') do
          response = SendToFirebase.new(people_params).call

          expect(response.success?).to be(false)
        end
      end
    end
  end
end
