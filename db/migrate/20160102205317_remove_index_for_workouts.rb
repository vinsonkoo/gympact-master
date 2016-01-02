class RemoveIndexForWorkouts < ActiveRecord::Migration
  def change
    remove_index(:workouts, :name => 'index_user_id_3')
    remove_index(:workouts, :name => 'index_workouts_on_user_id_and_photo_id')
  end
end
