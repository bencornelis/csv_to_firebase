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

    @upload =
      Upload.new(firebase_app:  params[:firebase_app],
                 file_name:     file_name,
                 rows_count:    response.body.size,
                 columns_count: response.body.first.size)
                 
    if response.success? && @upload.save
      render :json => @upload
    else
      error = response.body["error"] || @upload.errors.full_messages.last
      render :json => { "error" => error }
    end
  end

  private

  def file_converter
    FileConverter.new(open_file)
  end

  def open_file
    FileOpener.new(params[:file]).open_file
  end

  def file_name
    params[:file].original_filename
  end

  def send_to_firebase
    FirebaseSender.new(
      objects:      file_converter.convert,
      file_name:    file_name,
      firebase_app: params[:firebase_app]
    ).send
  end
end
