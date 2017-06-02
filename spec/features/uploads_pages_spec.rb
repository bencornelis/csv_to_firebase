require "rails_helper"

# from http://blog.paulrugelhiatt.com/rails/testing/capybara/dropzonejs/2014/12/29/test-dropzonejs-file-uploads-with-capybara.html
def drop_in_dropzone(file_path)
  # Generate a fake input selector
  page.execute_script <<-JS
    fakeFileInput = window.$('<input/>').attr(
      {id: 'fakeFileInput', type:'file'}
    ).appendTo('body');
  JS
  # Attach the file to the fake input selector with Capybara
  attach_file("fakeFileInput", file_path)
  # Trigger the fake drop event
  page.execute_script <<-JS
    var fileList = [fakeFileInput.get(0).files[0]];
    var e = jQuery.Event('drop', { dataTransfer : { files : fileList } });
    $('.dropzone')[0].dropzone.listeners[0].events.drop(e);
  JS
end

describe "uploading a file", js: true do
  context "the upload is successful" do
    it "displays a link to the resources on firebase" do
      VCR.use_cassette('planets_csv') do
        visit root_path
        fill_in "firebase_app_url", with: "https://test-app.firebaseio.com/"
        drop_in_dropzone(Rails.root.join("spec/fixtures/files/planets.csv"))

        # a preview of the file is displayed
        expect(page).to have_content("planets.csv")
        expect(page).to have_content("Column headers: name, radius")
        expect(page).to have_content("Rows: 3")

        find("button.start").click

        expect(page).to have_content("https://test-app.firebaseio.com/")
      end
    end
  end
end
