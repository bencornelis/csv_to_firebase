class UploadsController < ApplicationController
  def new
    @upload = Upload.new
  end

  def create
    response = send_to_firebase

    if response.success?
      @upload =
        Upload.create(firebase_app:  params[:firebase_app],
                      file_name:     params[:file].original_filename,
                      rows_count:    response.body.size,
                      columns_count: response.body.first.size)

      render :json => {"message" => "Upload successful!",
                       "upload"  => @upload }
    else
      render :json => {"message" => response.body["error"]}
    end
  end

  private

  def convert_file_to_objects
    FileConverter.new(open_file).convert
  end

  def open_file
    FileOpener.new(params[:file]).open_file
  end

  def send_to_firebase
    FirebaseSender.new(
      objects: convert_file_to_objects,
      file_name: params[:file].original_filename,
      firebase_app: params[:firebase_app]
    ).send
  end
end
