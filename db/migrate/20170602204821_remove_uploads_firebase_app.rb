class RemoveUploadsFirebaseApp < ActiveRecord::Migration
  def change
    remove_column :uploads, :firebase_app
  end
end
