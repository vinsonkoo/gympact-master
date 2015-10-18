class AddChatAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :chats, :pact_id, :integer
    add_index 'chats', ['pact_id'], :name => 'index_pact_id_2' 
  end

  def self.down
    remove_column :chats, :pact_id
  end
end
