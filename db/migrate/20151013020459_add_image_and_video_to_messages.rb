class AddImageAndVideoToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :image, :string
    add_column :messages, :video, :string
  end
end
