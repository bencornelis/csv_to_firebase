class SendToFirebase
  BATCH_SIZE = 10_000

  def initialize(params)
    @spreadsheet  = params[:spreadsheet]
    @firebase_app = params[:firebase_app]
    @file_name    = params[:file_name]
  end

  def call
    hydra = Typhoeus::Hydra.hydra

    requests =
      batches.map do |batch|
        request = build_request(batch)
        hydra.queue(request)
        request
      end

    hydra.run

    responses = requests.map(&:response)
    BatchedResponse.new(responses)
  end

private

  attr_reader :spreadsheet, :firebase_app, :file_name

  def batches
    objects_batched = 0
    batches = []

    objects.each_slice(BATCH_SIZE) do |objs|
      ids = (objects_batched..objects_batched + BATCH_SIZE)
      batches << Hash[ids.zip(objs)]

      objects_batched += BATCH_SIZE
    end
    batches
  end

  def objects
    @objects ||= spreadsheet.to_a
  end

  def build_request(batch)
    Typhoeus::Request.new(
      app_url,
      method: :patch,
      body: batch.to_json,
      headers: {"Content-Type" => "application/json"}
    )
  end

  def app_url
    "https://#{firebase_app}.firebaseio.com/#{resource}.json"
  end

  def resource
    File.basename(file_name, ".*")
  end
end

class BatchedResponse
  attr_reader :responses

  def initialize(responses)
    @responses = responses
  end

  def success?
    responses.all?(&:success?)
  end

  def error_message
    first_failed = responses.find { |response| !response.success? }
    return unless first_failed

    body = JSON.parse(first_failed.body)
    body["error"]
  end
end
