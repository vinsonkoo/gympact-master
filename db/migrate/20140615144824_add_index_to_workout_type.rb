class AddIndexToWorkoutType < ActiveRecord::Migration
  def change
  	add_index :workout_types, ["workout_id", "workout_type"], :unique => true
  end
end
