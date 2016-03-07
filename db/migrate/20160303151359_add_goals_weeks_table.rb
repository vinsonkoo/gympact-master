class AddGoalsWeeksTable < ActiveRecord::Migration
  def change
    create_table :goals_weeks, :id => false do |t|
      t.integer :goal
      t.integer :pact_id
      t.integer :user_id
      t.integer :week_id
    end

    drop_table :pacts_goals
  end
end
