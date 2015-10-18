class AddPhotoAssociationToMessage < ActiveRecord::Migration
  def self.up
    add_column :photos, :message_id, :integer
    add_index 'photos', ['message_id'], :name => 'index_message_id' 
  end

  def self.down
    remove_column :photos, :message_id
  end
end
