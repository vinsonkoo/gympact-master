class AddPenaltiesAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :penalties, :pact_id, :integer
    add_index 'penalties', ['pact_id'], :name => 'index_pact_id' 
  end

  def self.down
    remove_column :penalties, :pact_id
  end
end
