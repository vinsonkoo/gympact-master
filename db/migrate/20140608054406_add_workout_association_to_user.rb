class AddWorkoutAssociationToUser < ActiveRecord::Migration
  def self.up
    add_column :workouts, :user_id, :integer
    add_index 'workouts', ['user_id'], :name => 'index_user_id_3' 
  end

  def self.down
    remove_column :workouts, :user_id
  end
end
