class FirebaseSender
  def initialize(args)
    @objects = args[:objects]
    @firebase_app = args[:firebase_app]
    @resource = File.basename(args[:file_name], ".*")
  end

  def send
    client = Firebase::Client.new("https://#{firebase_app}.firebaseio.com/")
    # batch the requests
    client.set(resource, objects)
  end

private

  attr_reader :objects, :firebase_app, :resource
end
