class RemoveIdFalseFromPenalties < ActiveRecord::Migration
  def change

    drop_table :penalties 

    create_table :penalties do |t|
      t.integer :goal_days
      t.float :penalty

      t.timestamps
    end
  end
end
