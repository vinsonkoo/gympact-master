class AddGoalAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :goals, :pact_id, :integer
    add_index 'goals', ['pact_id'], :name => 'index_pact_id_6' 
  end

  def self.down
    remove_column :goals, :pact_id
  end
end
