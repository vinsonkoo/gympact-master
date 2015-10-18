class AddIndexToWeek < ActiveRecord::Migration
  def change
  	add_index :weeks, ["pact_id", "week_number"], :unique => true
  end
end
