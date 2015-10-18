class AddWorkoutTypesAssociationToWorkout < ActiveRecord::Migration
  def self.up
    add_column :workout_types, :workout_id, :integer
    add_index 'workout_types', ['workout_id'], :name => 'index_workout_id' 
  end

  def self.down
    remove_column :workout_types, :workout_id
  end
end
