class SendToFirebase
  def initialize(params)
    @spreadsheet  = params[:spreadsheet]
    @url          = params[:url]
    @file_name    = params[:file_name]
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
