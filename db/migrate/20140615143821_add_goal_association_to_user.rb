class AddGoalAssociationToUser < ActiveRecord::Migration
  def self.up
    add_column :goals, :user_id, :integer
    add_index 'goals', ['user_id'], :name => 'index_user_id_5' 
  end

  def self.down
    remove_column :goals, :user_id
  end
end
