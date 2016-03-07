class AddMediaFilenameToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :media_filename, :string
  end
end
