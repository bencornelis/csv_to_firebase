class UploadsController < ApplicationController
  def new
  end

  def file_metadata
    metadata = file_converter.metadata

    if metadata[:column_headers].any?(&:nil?)
      render :json => { "error" => "Some headers were empty." }
    else
      render :json => metadata
    end
  end

  def create
    response = send_to_firebase
    sleep(1)

    if response.success?
      @upload =
        Upload.create(firebase_app:  params[:firebase_app],
                      file_name:     params[:file].original_filename,
                      rows_count:    response.body.size,
                      columns_count: response.body.first.size)

      render :json => { "upload"  => @upload }
    else
      render :json => {"error" => response.body["error"] }
    end
  end

  private

  def file_converter
    FileConverter.new(open_file)
  end

  def open_file
    FileOpener.new(params[:file]).open_file
  end

  def send_to_firebase
    FirebaseSender.new(
      file_converter.convert,
      params.permit(:file, :firebase_app)
    ).send
  end
end
