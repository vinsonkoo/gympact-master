class AddIndexToGoal < ActiveRecord::Migration
  def change
  	add_index :goals, ["pact_id", "user_id", "week_id"], :unique => true
  end
end
