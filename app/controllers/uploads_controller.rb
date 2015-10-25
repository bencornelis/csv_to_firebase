class UploadsController < ApplicationController
  def new
  end

  def column_headers
    opened_file = open_file
    headers = opened_file.row(1)

    if headers.any?(&:nil?)
      render :json => { "error" => "Some headers were empty." }
    else
      render :json => { "column_headers" => headers,
                        "rows_count"     => opened_file.last_row - 1 }
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
