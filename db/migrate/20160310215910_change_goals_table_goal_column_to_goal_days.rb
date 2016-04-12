class ChangeGoalsTableGoalColumnToGoalDays < ActiveRecord::Migration
  def change
    rename_column :goals, :goal, :goal_days
  end
end
