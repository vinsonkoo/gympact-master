class AddSentToWorkouts < ActiveRecord::Migration
  def up
  	add_column :workouts, :sent, :datetime
  end

  def down
    remove_column :workouts, :sent
  end
end
