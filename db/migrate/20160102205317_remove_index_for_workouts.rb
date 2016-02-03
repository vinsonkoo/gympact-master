class RemoveIndexForWorkouts < ActiveRecord::Migration
  def change
    remove_index(:workouts, :name => 'index_user_id_3')
  end
end
