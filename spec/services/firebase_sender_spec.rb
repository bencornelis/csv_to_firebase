require "rails_helper"

describe FirebaseSender do
  let(:planets_csv) do
    fixture_file_upload(
      "/files/planets.csv",
      "text/csv"
      )
  end

  let(:objects) do
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

  describe "#send" do
    it "returns a response object that responds to success?" do
      VCR.use_cassette('planets_csv') do
        firebase_sender =
          FirebaseSender.new(objects, firebase_app: "test-app", file: planets_csv)
          
        expect(firebase_sender.send).to respond_to(:success?)
      end
    end
  end
end
