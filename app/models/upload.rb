class Upload < ActiveRecord::Base
  validates :firebase_app, presence: true
  validates :file_name, presence: true
  validates :rows_count, presence: true
  validates :columns_count, presence: true

  before_create :set_resource

private
  def set_resource
    self.resource = File.basename(file_name, ".*")
  end
end
