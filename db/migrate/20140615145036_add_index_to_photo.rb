class AddIndexToPhoto < ActiveRecord::Migration
  def change
  	add_index :photos, ["message_id", "photo_url"], :unique => true
  end
end
