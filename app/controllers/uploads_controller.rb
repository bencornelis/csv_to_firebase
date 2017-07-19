class UploadsController < ApplicationController
  def new
  end

  def file_metadata
    if ValidateHeaders.new(spreadsheet).call
      render :json => spreadsheet.metadata
    else
      render :json => { error: "Some headers were empty or contain the characters . $ # [ ] or /." }
    end
  end

  def create
    response = send_spreadsheet_to_firebase
    @upload = Upload.build(upload_params, response)

    if response.success? && @upload.save
      render :json => @upload
    else
      error = response.body["error"] || @upload.errors.full_messages.last
      render :json => { :error => error }
    end
  end

  private

  def upload_params
    params.permit(:file, :firebase_app_url)
  end

  def spreadsheet
    @spreadsheet ||= Spreadsheet.build(params[:file])
  end

  def send_spreadsheet_to_firebase
    SendToFirebase.new(spreadsheet, upload_params).call
  end
end
