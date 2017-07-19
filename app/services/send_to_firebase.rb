class SendToFirebase
  def initialize(spreadsheet, params)
    @spreadsheet = spreadsheet
    @url         = params[:firebase_app_url]
    @file_name   = params[:file].original_filename
  end

  def call
    client = Firebase::Client.new(url)
    client.set(resource, objects)
  end

private

  attr_reader :spreadsheet, :url, :file_name

  def objects
    spreadsheet.to_a
  end

  def resource
    File.basename(file_name, ".*")
  end
end
