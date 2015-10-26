require 'rails_helper'

RSpec.describe Upload, type: :model do
  it { should validate_presence_of :firebase_app }
  it { should validate_presence_of :file_name }
  it { should validate_presence_of :rows_count }
  it { should validate_presence_of :columns_count }

  it "sets the resource name and url on creation" do
    upload = Upload.create(
      firebase_app:  "test-app",
      file_name:     "planets.csv",
      rows_count:    3,
      columns_count: 2
      )

    expect(upload.resource).to eq("planets")
    expect(upload.url).to eq("https://test-app.firebaseio.com/planets")
  end
end
