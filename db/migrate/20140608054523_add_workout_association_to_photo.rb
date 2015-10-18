class AddWorkoutAssociationToPhoto < ActiveRecord::Migration
  def self.up
    add_column :workouts, :photo_id, :integer
    add_index 'workouts', ['photo_id'], :name => 'index_photo_id' 
  end

  def self.down
    remove_column :workouts, :photo_id
  end
end
