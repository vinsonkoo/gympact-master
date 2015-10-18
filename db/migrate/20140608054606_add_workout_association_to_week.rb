class AddWorkoutAssociationToWeek < ActiveRecord::Migration
  def self.up
    add_column :workouts, :week_id, :integer
    add_index 'workouts', ['week_id'], :name => 'index_week_id' 
  end

  def self.down
    remove_column :workouts, :week_id
  end
end
