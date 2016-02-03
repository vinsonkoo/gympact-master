class RemoveIndexForWorkouts < ActiveRecord::Migration
  def change
    remove_index(:workouts, :name => 'index_user_id_3')
    remove_index(:workouts, :name => 'index_workout_types_on_workout_id_and_workout_type')
  end
end
