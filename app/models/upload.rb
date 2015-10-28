class Upload < ActiveRecord::Base
  validates :firebase_app, presence: true
  validates :file_name, presence: true
  validates :rows_count, presence: true
  validates :columns_count, presence: true

  before_create :set_resource
  before_create :set_url

  def self.build(params, firebase_response)
    new(firebase_app:  params[:firebase_app],
        file_name:     params[:file].original_filename,
        rows_count:    firebase_response.body.size,
        columns_count: firebase_response.body.first.size)
  end

private
  def set_resource
    self.resource = File.basename(file_name, ".*")
  end

  def set_url
    self.url = "https://#{firebase_app}.firebaseio.com/#{resource}"
  end
end
