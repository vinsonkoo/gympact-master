class AddIndexToWorkout < ActiveRecord::Migration
  def change
  	add_index :workouts, ["user_id", "photo_id"], :unique => true
  end
end
