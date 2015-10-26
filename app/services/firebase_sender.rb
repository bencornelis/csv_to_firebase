class FirebaseSender
  def initialize(objects, params)
    @objects = objects
    @firebase_app = params[:firebase_app]
    @resource = File.basename(params[:file].original_filename, ".*")
  end

  def send
    client = Firebase::Client.new("https://#{firebase_app}.firebaseio.com/")
    # batch the requests
    client.set(resource, objects)
  end

private

  attr_reader :objects, :firebase_app, :resource
end
