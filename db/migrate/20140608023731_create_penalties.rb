class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.integer :goal_days
      t.float :penalty

      t.timestamps
    end
  end
end
