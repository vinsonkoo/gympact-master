class RemoveColumnsFromWorkout < ActiveRecord::Migration
  def up
    remove_column :workouts, :date
    remove_column :workouts, :time
  end

  def down
    add_column :workouts, :date, :date
    add_column :workouts, :time, :time
  end
end
