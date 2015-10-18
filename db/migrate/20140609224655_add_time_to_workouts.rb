class AddTimeToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :time, :time
  end
end
