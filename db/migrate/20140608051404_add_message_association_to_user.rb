class AddMessageAssociationToUser < ActiveRecord::Migration
  def self.up
    add_column :messages, :user_id, :integer
    add_index 'messages', ['user_id'], :name => 'index_user_id' 
  end

  def self.down
    remove_column :messages, :user_id
  end
end
