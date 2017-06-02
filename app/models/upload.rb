class Upload < ActiveRecord::Base
  validates :url, presence: true
  validates :file_name, presence: true
  validates :rows_count, presence: true
  validates :columns_count, presence: true

  before_create :set_resource
  before_create :append_resource_to_url

  def self.build(params, firebase_response)
    new(url:           params[:firebase_app_url],
        file_name:     params[:file].original_filename,
        rows_count:    firebase_response.body.size,
        columns_count: firebase_response.body.first.size)
  end

private
  def set_resource
    self.resource = File.basename(file_name, ".*")
  end

  def append_resource_to_url
    self.url += resource
  end
end
