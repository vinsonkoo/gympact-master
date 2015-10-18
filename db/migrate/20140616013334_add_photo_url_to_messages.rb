class AddPhotoUrlToMessages < ActiveRecord::Migration
  def up
  	add_column :messages, :photo_url, :string
  end

  def down
    remove_column :messages, :photo_url
  end
end
