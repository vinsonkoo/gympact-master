class ChangeGoalsPactsTable < ActiveRecord::Migration
  def change
    add_column :goals_pacts, :goal_id, :integer
    remove_column :goals_pacts, :goal, :integer
    remove_column :goals_pacts, :user_id, :integer
    remove_column :goals_pacts, :week_id, :integer
  end
end
