require "rails_helper"

describe FirebaseSender do
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

  let(:invalid_objects) do
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

  let(:params) do
    {
      objects:      objects,
      firebase_app: "test-app",
      file_name:    "planets.csv"
    }
  end

  let(:invalid_params) do
    {
      objects:      invalid_objects,
      firebase_app: "test-app",
      file_name:    "invalid.csv"
    }
  end

  describe "#send" do
    it "returns a response object that responds to success?" do
      VCR.use_cassette('planets_csv') do
        expect(
          FirebaseSender.new(params).send
        ).to respond_to(:success?)
      end
    end

    context "the objects have nonempty keys" do
      it "is successful" do
        VCR.use_cassette('planets_csv') do
          response = FirebaseSender.new(params).send

          expect(response.success?).to be(true)
        end
      end
    end

    context "one of the keys is empty" do
      it "is unsuccessful" do
        VCR.use_cassette('invalid_csv') do
          response = FirebaseSender.new(invalid_params).send

          expect(response.success?).to be(false)
        end
      end
    end
  end
end
