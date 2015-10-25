class AddResourceToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :resource, :string
  end
end
