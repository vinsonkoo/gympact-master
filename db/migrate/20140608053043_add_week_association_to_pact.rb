class AddWeekAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :weeks, :pact_id, :integer
    add_index 'weeks', ['pact_id'], :name => 'index_pact_id_3' 
  end

  def self.down
    remove_column :weeks, :pact_id
  end
end
