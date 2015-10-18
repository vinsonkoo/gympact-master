class AddGoalAssociationToWeek < ActiveRecord::Migration
  def self.up
    add_column :goals, :week_id, :integer
    add_index 'goals', ['week_id'], :name => 'index_week_id_2' 
  end

  def self.down
    remove_column :goals, :week_id
  end
end
