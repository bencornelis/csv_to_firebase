class Upload < ActiveRecord::Base
  validates :firebase_app, presence: true
  validates :file_name, presence: true
  validates :rows_count, presence: true
  validates :columns_count, presence: true
end
