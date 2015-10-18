class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.date :start_date
      t.date :end_date
      t.integer :week_number
      t.integer :goal_days
      t.integer :missed_days
      t.float :charge
      t.float :paid

      t.timestamps
    end
  end
end
