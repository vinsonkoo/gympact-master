class AddMessageAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :messages, :pact_id, :integer
    add_index 'messages', ['pact_id'], :name => 'index_pact_id_4' 
  end

  def self.down
    remove_column :messages, :pact_id
  end
end
