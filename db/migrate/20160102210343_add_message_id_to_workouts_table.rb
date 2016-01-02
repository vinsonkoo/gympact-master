class AddMessageIdToWorkoutsTable < ActiveRecord::Migration
  def change
    add_column :workouts, :message_id, :integer
  end
end
