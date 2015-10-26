require 'rails_helper'

RSpec.describe Upload, type: :model do
  it { should validate_presence_of :firebase_app }
  it { should validate_presence_of :file_name }
  it { should validate_presence_of :rows_count }
  it { should validate_presence_of :columns_count }
end
