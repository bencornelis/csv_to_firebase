class SendToFirebase
  def initialize(params)
    @spreadsheet  = params[:spreadsheet]
    @firebase_app = params[:firebase_app]
    @file_name    = params[:file_name]
  end

  def call
    client = Firebase::Client.new("https://#{firebase_app}.firebaseio.com/")

    objects_sent = 0
    res = nil
    objects.each_slice(1000) do |objs|
      ids = (objects_sent..objects_sent + 1000)
      data = Hash[ids.zip(objs)]
      res = client.update(resource, data)

      return res unless res.success?
      objects_sent += 1000
    end
    res
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
