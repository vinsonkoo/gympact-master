class AddMediaToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :media, :boolean
  end
end
