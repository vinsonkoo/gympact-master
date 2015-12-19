class AddGoalsPactsTable < ActiveRecord::Migration
  def change
    create_table :goals_pacts, :id => false do |t|
      t.integer :goal
      t.integer :pact_id
      t.integer :user_id
      t.integer :week_id
    end
  end
end
