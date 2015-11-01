class Upload < ActiveRecord::Base
  validates :firebase_app, presence: true
  validates :file_name, presence: true
  validates :rows_count, presence: true
  validates :columns_count, presence: true

  before_save :set_resource
  before_save :set_url

private
  def set_resource
    self.resource = File.basename(file_name, ".*")
  end

  def set_url
    self.url = "https://#{firebase_app}.firebaseio.com/#{resource}"
  end
end
