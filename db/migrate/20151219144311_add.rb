class Add < ActiveRecord::Migration
  def change
    create_table :pacts_goals, :id => false do |t|
      t.integer :pact_id
      t.integer :goal_id
    end
  end
end
