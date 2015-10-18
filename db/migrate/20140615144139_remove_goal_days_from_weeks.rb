class RemoveGoalDaysFromWeeks < ActiveRecord::Migration
  def up
    remove_column :weeks, :goal_days
    remove_column :weeks, :missed_days
    remove_column :weeks, :charge
    remove_column :weeks, :paid
  end

  def down
    add_column :weeks, :goal_days, :integer
    add_column :weeks, :missed_days, :integer
    add_column :weeks, :charge, :float
    add_column :weeks, :paid, :float
  end
end
