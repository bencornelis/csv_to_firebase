class SendToFirebase
  def initialize(params)
    @spreadsheet  = params[:spreadsheet]
    @firebase_app = params[:firebase_app]
    @file_name    = params[:file_name]
  end

  def call
    client = Firebase::Client.new("https://#{firebase_app}.firebaseio.com/")
    client.set(resource, objects)
  end

private

  attr_reader :spreadsheet, :firebase_app, :file_name

  def objects
    spreadsheet.to_a
  end

  def resource
    File.basename(file_name, ".*")
  end
end
