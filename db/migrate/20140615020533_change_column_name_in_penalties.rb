class ChangeColumnNameInPenalties < ActiveRecord::Migration
  def up
  	rename_column :penalties, :goal_days, :goal
  end

  def down
  	rename_column :penalties, :goal, :goal_days
  end
end
