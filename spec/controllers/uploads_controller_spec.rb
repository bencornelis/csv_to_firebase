require "rails_helper"

describe UploadsController do
  let(:planets_csv) do
    fixture_file_upload(
      "/files/planets.csv",
      "text/csv"
      )
  end

  let(:invalid_csv) do
    fixture_file_upload(
      "/files/invalid.csv",
      "text/csv"
      )
  end

  describe "GET #new" do
    it "renders the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #file_metadata" do
    context "the file has nonempty headers" do
      it "renders the file metadata as json" do
        post :file_metadata, format: :json, file: planets_csv

        body = JSON.parse(response.body)
        expect(body).to eq({
          "column_headers" => ["name", "radius"],
          "rows_count" => 3
        })
      end
    end

    context "the file has some empty headers" do
      it "renders an error message as json" do
        post :file_metadata, format: :json, file: invalid_csv

        body = JSON.parse(response.body)
        expect(body).to eq({
          "error" => "Some headers were empty."
        })
      end
    end
  end

  describe "POST #create" do
    context "the file and firebase app are valid" do
      it "sends the file objects to firebase" do
        VCR.use_cassette('planets_csv') do
          expect_any_instance_of(FirebaseSender).to receive(:send).once.and_call_original

          post :create, { file: planets_csv, firebase_app: "test-app" }
        end
      end

      it "creates a new upload" do
        VCR.use_cassette('planets_csv') do
          expect {
            post :create, { file: planets_csv, firebase_app: "test-app" }
          }.to change(Upload, :count).by(1)
        end
      end

      it "renders the upload as json" do
        VCR.use_cassette('planets_csv') do
          post :create, { file: planets_csv, firebase_app: "test-app" }

          upload = Upload.first
          expect(response.body).to eq(upload.to_json)
        end
      end
    end

    context "the file is not valid" do
      it "renders an error message as json" do
        VCR.use_cassette('invalid_csv') do
          post :create, { file: invalid_csv, firebase_app: "test-app" }

          body = JSON.parse(response.body)
          expect(body["error"]).not_to be_nil
        end
      end

      it "does not create an upload" do
        VCR.use_cassette('invalid_csv') do
          expect {
            post :create, { file: invalid_csv, firebase_app: "test-app" }
          }.not_to change(Upload, :count)
        end
      end
    end

    context "the firebase app is not valid" do
      it "renders an error message as json" do
        VCR.use_cassette('invalid_app_planets_csv') do
          post :create, { file: planets_csv, firebase_app: "asdgasdgsd" }

          body = JSON.parse(response.body)
          expect(body["error"]).not_to be_nil
        end
      end

      it "does not create an upload" do
        VCR.use_cassette('invalid_app_planets_csv') do
          expect {
            post :create, { file: planets_csv, firebase_app: "asdgasdgsd" }
          }.not_to change(Upload, :count)
        end
      end
    end
  end
end
