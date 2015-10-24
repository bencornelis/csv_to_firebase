class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :firebase_app
      t.string :file_name
      t.integer :rows_count
      t.integer :columns_count
      
      t.timestamps null: false
    end
  end
end
