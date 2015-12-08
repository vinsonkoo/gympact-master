class RemovePenaltyFromPacts < ActiveRecord::Migration
  def change
    remove_column :pacts, :penalty, :float

    drop_table :penalties 

    create_table :penalties, id: false do |t|
      t.integer :goal_days
      t.float :penalty

      t.timestamps
    end
  end
end
