class UploadsController < ApplicationController

  def new
  end

  def file_metadata
    if ValidateHeaders.new(spreadsheet.headers).call
      render :json => metadata
    else
      render :json => { error: "Some headers were empty or contain the characters . $ # [ ] or /." }
    end
  end

  def create
    response = send_spreadsheet_to_firebase

    @upload =
      Upload.new(
        firebase_app:  params[:firebase_app],
        file_name:     params[:file].original_filename,
        rows_count:    metadata[:rows_count],
        columns_count: metadata[:headers].size
      )

    if response.success? && @upload.save
      render :json => @upload
    else
      error = response.error_message || @upload.errors.full_messages.last
      render :json => { "error" => error }
    end
  end

  private

  def upload_params
    params.permit(:file, :firebase_app)
  end

  def spreadsheet
    @spreadsheet ||= Spreadsheet.build(params[:file])
  end

  def metadata
    @metadata ||= spreadsheet.metadata
  end

  def send_spreadsheet_to_firebase
    SendToFirebase.new(
      spreadsheet:  spreadsheet,
      file_name:    params[:file].original_filename,
      firebase_app: params[:firebase_app]
    ).call
  end
end
